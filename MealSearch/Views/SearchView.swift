//
//  SearchView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI
import SwiftData

class RecipeAPIHandler: ObservableObject {
    var tabStore: IngredientTabStore
    let context: ModelContext
    var recipeStore: [RecipeStore]

    @Binding var isLoading: Bool
    @Binding var prevIngredients: [IngredientModel]
    @Binding var allRecipes: [RecipeModel]
    @Binding var filteredRecipes: [RecipeModel]
        
    init(
        tabStore: IngredientTabStore,
        context: ModelContext,
        recipeStore: [RecipeStore],
        isLoading: Binding<Bool>,
        prevIngredients: Binding<[IngredientModel]>,
        allRecipes: Binding<[RecipeModel]>,
        filteredRecipes: Binding<[RecipeModel]>
    ) {
        self.tabStore = tabStore
        self.context = context
        self.recipeStore = recipeStore
        self._isLoading = isLoading
        self._prevIngredients = prevIngredients
        self._allRecipes = allRecipes
        self._filteredRecipes = filteredRecipes
    }

    func loadRecipesFromAPI(query: String = "") async -> [RecipeModel] {
        guard tabStore.tabs.indices.contains(0) else {
            print("No tabs initialized yet, skipping recipe load")
            return []
        }

        // Don't fetch if there are no ingredients stored
        let pantryIngredients = tabStore.tabs[0].list.ingredients
        if pantryIngredients.isEmpty {
            return []
        }

        // Prevent unnecessary API calls if pantry is unchanged and there are saved recipes
        if !allRecipes.isEmpty && ingredientListEqual(prevIngredients, pantryIngredients) { return [] }
        if !recipeStore[0].fetchedRecipes.isEmpty { return [] }

        let recipes = await fetchRecipes(ingredients: pantryIngredients, query: query)
        
        // Make latest result persistent
        recipeStore[0].setFetchedRecipes(recipes: recipes, context: context)

        prevIngredients = pantryIngredients  // store to compare later
        isLoading = false
        
        return recipes
    }
    
    func loadRecipesFromAPI(currentRecipes: [RecipeModel], offset: Int, query: String = "") async -> [RecipeModel] {
        let pantryIngredients = tabStore.tabs[0].list.ingredients
        
        let newRecipes = await fetchRecipes(ingredients: pantryIngredients, offset: offset, query: query)
        
        // Filter out recipes that exist in list already
        let newRecipesFiltered = newRecipes.filter {
            recipe in
            !allRecipes.contains(where: { $0.id == recipe.id })
        }
        
        let addedRecipes = currentRecipes + newRecipesFiltered
        filteredRecipes += newRecipesFiltered
        
        // Make latest result persistent
        recipeStore[0].setFetchedRecipes(recipes: addedRecipes, context: context)
        
        return addedRecipes
    }
    
    private func fetchRecipes(ingredients: [IngredientModel], offset: Int = 0, query: String = "") async -> [RecipeModel] {
        let result = await APIHandler.shared.searchRecipes(from: ingredients, number: offset + 10, query: query)
        
        // sorts the recipes based on maximized used ingredients and minimized missed ingredients
        let recipes = result.sorted { recipe1, recipe2 in
            if recipe1.usedIngredientCount != recipe2.usedIngredientCount {
                return (recipe1.usedIngredientCount ?? 0) > (recipe2.usedIngredientCount ?? 0)
            }
            return(recipe1.missedIngredientCount ?? 0) < (recipe2.missedIngredientCount ?? 0)
        }
        
        return recipes
    }
    
    // allows IngredientModel lists to be equatable
    private func ingredientListEqual(_ a: [IngredientModel], _ b: [IngredientModel]) -> Bool {
        let aIDs = a.map { $0.id }.sorted()
        let bIDs = b.map { $0.id }.sorted()
        return aIDs == bIDs
    }
}


// Displays a list of recipes with optional search filtering and pagination.
struct RecipeList: View {
    @Binding var allRecipes: [RecipeModel]
    @Binding var filteredRecipes: [RecipeModel]
    @Binding var isTabBarHidden: Bool
    @Binding var searchQuery: String
    var recipeAPIHandler: RecipeAPIHandler? = nil
    
    @State private var loadMore: Bool = false
    
    // Show all recipes unless searching
    var visibleRecipes: [RecipeModel] {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            ? allRecipes
            : filteredRecipes
    }
    
    private func loadMoreRecipes(query: String) async {
        if let recipeAPIHandler {
            let addedRecipes = await recipeAPIHandler.loadRecipesFromAPI(
                currentRecipes: allRecipes,
                offset: allRecipes.count,
                query: query
            )
            allRecipes = addedRecipes
        } else {
            print("Error loading more recipes")
        }
        loadMore = false
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                
                // Empty search results
                if filteredRecipes.isEmpty && searchQuery.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    VStack {
                        Text("No results found. \n Try loading more recipes")
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                    }
                }
                
                // Show Recipe cards if valid search results
                else {
                    ForEach(visibleRecipes) { recipe in
                        NavigationLink {
                            RecipeDetailsView(
                                recipeSummary: recipe,
                                isTabBarHidden: $isTabBarHidden
                            )
                            .onAppear { isTabBarHidden = true }
                            .onDisappear { isTabBarHidden = false }
                        } label: {
                            RecipeCardView(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // Fetch recipes and add to existing lists when reached bottom of view and click "Load more recipes"
                if (recipeAPIHandler != nil) {
                    if loadMore {
                        ProgressView()
                            .scaleEffect(1.3)
                            .padding(.top, 10)
                            .task {
                                await loadMoreRecipes(query: searchQuery)
                            }
                    } else {
                        Button {
                            loadMore = true
                        } label: {
                            Text("Load more recipes")
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.primaryRed)
                        }
                        .padding(.vertical, 30)
                        .buttonStyle(.plain)
                        .fontWeight(.medium)
                        .font(.title2)
                        .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
    }
}

// Handles RecipeList for FavoritesView
extension RecipeList {
    init(
        recipes: Binding<[RecipeModel]>,
        isTabBarHidden: Binding<Bool>
    ) {
        self._allRecipes = recipes
        self._filteredRecipes = recipes
        self._isTabBarHidden = isTabBarHidden
        
        self._searchQuery = .constant("")
        self.recipeAPIHandler = nil
    }
}

struct SearchView: View {
    @Environment(\.modelContext) private var context
    @Query private var recipeStore: [RecipeStore]
    
    @Binding var isTabBarHidden: Bool
    @Binding var selectedTab: Int

    @EnvironmentObject var tabStore: IngredientTabStore

    @State private var allRecipes: [RecipeModel] = []
    @State private var filteredRecipes: [RecipeModel] = []

    @State private var prevIngredients: [IngredientModel] = []
    @State private var isLoading = false
    @State private var searchQuery = ""
    
    private var handler: RecipeAPIHandler {
        RecipeAPIHandler(
            tabStore: tabStore,
            context: context,
            recipeStore: recipeStore,
            isLoading: $isLoading,
            prevIngredients: $prevIngredients,
            allRecipes: $allRecipes,
            filteredRecipes: $filteredRecipes
        )
    }
    
    func filterRecipes() -> Void {
        filteredRecipes = allRecipes.filter {
            $0.title.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundCream")
                    .ignoresSafeArea()
                
                if isLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Searching recipes...")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 140)
                }
                
                else if allRecipes.isEmpty {
                    let pantry = tabStore.tabs.indices.contains(0)
                        ? tabStore.tabs[0].list.ingredients
                        : []
                    
                    VStack(spacing: 16) {
                        if pantry.isEmpty {
                            VStack {
                                Text("Add your ingredients")
                                    .fontWeight(.bold)
                                Text("to start searching for recipes")
                            }
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            
                            Image(systemName: "archivebox")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.7))
                            
                            Button {
                                selectedTab = 0
                            } label: {
                                Text("Find Ingredients")
                            }
                            .buttonStyle(.plain)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.primaryRed)
                                    .shadow(color: .gray, radius: 2, x: -1, y: 2)
                            }
                            .foregroundStyle(.white)
                            .font(.title)
                        }
                        else {
                            Text("No Recipes Found")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 24)
                            
                            Image(systemName: "exclamationmark.magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.7))
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 140)
                }
                
                else {
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.title)
                            TextField(text: $searchQuery) {
                                Text("Search recipes here")
                                    .foregroundStyle(.white)
                            }
                            .onChange(of: searchQuery, initial: false) {
                                oldVal, newVal in
                                if newVal.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                                    filteredRecipes = allRecipes
                                } else {
                                    filterRecipes()
                                }
                            }
                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding(.leading, 10)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.primaryRed)
                        }
                        .shadow(color: .black.opacity(0.4), radius: 4, y: 2)
                        .padding(.horizontal, 20)
//                        .padding(.bottom, 10)
                        .padding(.top, 20)
                    
                        // Display recipes
                        RecipeList(
                            allRecipes: $allRecipes,
                            filteredRecipes: $filteredRecipes,
                            isTabBarHidden: $isTabBarHidden,
                            searchQuery: $searchQuery,
                            recipeAPIHandler: handler
                        )
                    }
                    
                }
            }
            .navigationBarTitle("Meal Search", displayMode: .large)
        }
        .task {
            isLoading = true
            let fetched = await handler.loadRecipesFromAPI()
            
            if !fetched.isEmpty { allRecipes = fetched }
            isLoading = false
        }
        .onAppear {
            if !recipeStore[0].fetchedRecipes.isEmpty {
                allRecipes = recipeStore[0].fetchedRecipes
            }
        }
    }
}

//#Preview {
//    SearchView(isTabBarHidden: .constant(false), selectedTab: .constant(1))
//        .environmentObject(IngredientTabStore())
//}

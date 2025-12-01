//
//  SearchView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI
import SwiftData

// Displays a list of recipes with optional search filtering and pagination.
struct RecipeList: View {
    var displayedRecipes: [RecipeModel]
    var isSearchEmpty: Bool
    @Binding var isTabBarHidden: Bool
    @Binding var isLoadingMore: Bool
    
    // Function for realizing when to load more
    var loadMore:(() -> Void)? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                
                // Empty search results
                if isSearchEmpty {
                    VStack {
                        Text("No results found. \n Try loading more recipes")
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                            .frame(alignment: .top)
                    }
                }
                
                // Show Recipe cards if valid search results

                ForEach(displayedRecipes) {
                    recipe in
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
                
                // Fetch recipes and add to existing lists when reached bottom of view and click "Load more recipes"
                if let loadMore {
                    if isLoadingMore {
                        ProgressView()
                            .scaleEffect(1.3)
                            .padding(.vertical, 25)
                    } else {
                        Button {
                            loadMore()
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

struct SearchView: View {
    @Environment(\.modelContext) private var context
    @Query private var recipeStore: [RecipeStore]
    
    @State private var currentOffset = 0
    @State private var isLoadingMore = false
    @State private var reachedEnd = false
    
    @Binding var isTabBarHidden: Bool
    @Binding var selectedTab: Int

    @EnvironmentObject var tabStore: IngredientTabStore

    @State private var recipes: [RecipeModel] = []
    @State private var filteredRecipes: [RecipeModel] = []

    @State private var prevIngredients: [IngredientModel] = []
    @State private var isLoading = false
    @State private var searchQuery = ""
    
    var isSearchEmpty: Bool {
        filteredRecipes.isEmpty && searchQuery.trimmingCharacters(in: .whitespacesAndNewlines) != ""
    }
    
    // Display filtered recipes if searching, otherwise display all recipes
    var displayedRecipes: [RecipeModel] {
        if searchQuery.trimmingCharacters(in: .whitespaces).isEmpty {
            return recipes
        } else {
            return filteredRecipes
        }
    }
        
    func filterRecipes() -> Void {
        filteredRecipes = recipes.filter {
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
                
                else if recipes.isEmpty {
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
                                    filteredRecipes = recipes
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
                        .padding(.top, 20)
                        
                        RecipeList(
                            displayedRecipes: displayedRecipes,
                            isSearchEmpty: isSearchEmpty,
                            isTabBarHidden: $isTabBarHidden,
                            isLoadingMore: $isLoadingMore,
                            loadMore: {
                                Task { await loadMoreRecipes() }
                            }
                        )
                    }
                    
                }
            }
            .navigationBarTitle("Meal Search", displayMode: .large)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .task {
            await loadRecipesFromAPI()
        }
        .onAppear {
            if !recipeStore[0].fetchedRecipes.isEmpty {
                recipes = recipeStore[0].fetchedRecipes
            }
        }
    }

    private func loadRecipesFromAPI() async {
        guard tabStore.tabs.indices.contains(0) else {
            print("No tabs initialized yet, skipping recipe load")
            return
        }

        let pantryIngredients = tabStore.tabs[0].list.ingredients

        if pantryIngredients.isEmpty {
            recipes = []
            isLoading = false
            return
        }

        // Prevent unnecessary API calls
        if !recipes.isEmpty && ingredientListEqual(prevIngredients, pantryIngredients) { return }
        if !recipeStore[0].fetchedRecipes.isEmpty { return }

        isLoading = true
        let result = await fetchRecipes(ingredients: pantryIngredients)
        recipes = result

        // Make latest result persistent
        recipeStore[0].setFetchedRecipes(recipes: recipes, context: context)
        
        prevIngredients = pantryIngredients
        isLoading = false
    }

    private func ingredientListEqual(_ a: [IngredientModel], _ b: [IngredientModel]) -> Bool {
        let aIDs = a.map { $0.id }.sorted()
        let bIDs = b.map { $0.id }.sorted()
        return aIDs == bIDs
    }
    
    private func loadMoreRecipes() async {
        guard !isLoadingMore && !reachedEnd else { return }
        isLoadingMore = true

        let pantryIngredients = tabStore.tabs[0].list.ingredients
        
        // Getting more results
        let result = await fetchRecipes(
            ingredients: pantryIngredients,
            number: 10,
            offset: currentOffset + 10,
            query: searchQuery
        )
        
//        let result = await APIHandler.shared.searchRecipes(
//            from: pantryIngredients,
//            number: 10,
//            offset: currentOffset + 10,
//            query: searchQuery
//        )

        print(result)
        
        if result.isEmpty {
//            reachedEnd = true
        } else {
            await MainActor.run {
                recipes.append(contentsOf: result)
                if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    filteredRecipes.append(contentsOf: result)
                }
                
                // Make latest result persistent
                recipeStore[0].setFetchedRecipes(recipes: recipes, context: context)
                
                currentOffset += 10
            }
        }
        
        isLoadingMore = false
    }
    
    private func fetchRecipes(
        ingredients: [IngredientModel],
        number: Int = 10,
        offset: Int = 0,
        query: String = ""
    ) async -> [RecipeModel] {
        let result = await APIHandler.shared.searchRecipes(from: ingredients, number: number, offset: offset, query: query)
        
        // Sort fetched recipes by maximized used ingredients and minimized unused ingredients
        let newRecipes = result.sorted { recipe1, recipe2 in
            if recipe1.usedIngredientCount != recipe2.usedIngredientCount {
                return (recipe1.usedIngredientCount ?? 0) > (recipe2.usedIngredientCount ?? 0)
            }
            
            return(recipe1.missedIngredientCount ?? 0) < (recipe2.missedIngredientCount ?? 0)
        }
        
        // Filter recipes if fetched duplicates
        let filteredNewRecipes = newRecipes.filter {
            newRecipe in
            !recipes.contains {
                recipe in
                recipe.id == newRecipe.id
            }
        }
        print(filteredNewRecipes)
        
        return filteredNewRecipes
    }
}



//#Preview {
    //SearchView(isTabBarHidden: .constant(false), //selectedTab: .constant(1))
//         .environmentObject(IngredientTabStore())
//}

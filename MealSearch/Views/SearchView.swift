//
//  SearchView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI
import SwiftData

struct RecipeList: View {
    @Binding var recipes: [RecipeModel]
    @Binding var isTabBarHidden: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(recipes) { recipe in
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
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
    }
}

struct SearchView: View {
    @Environment(\.modelContext) private var context
    @Query private var recipeStore: [RecipeStore]
    
    @Binding var isTabBarHidden: Bool
    @Binding var selectedTab: Int

    @EnvironmentObject var tabStore: IngredientTabStore

    @State private var recipes: [RecipeModel] = []
//    @State private var recipes: [RecipeModel] = MockRecipes.all
    @State private var prevIngredients: [IngredientModel] = []
    @State private var isLoading = false
    @State private var searchQuery = ""
    @State private var filteredRecipes: [RecipeModel] = []
    
    func filterIngredients() -> Void {
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
                } else if recipes.isEmpty {
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
                                    filterIngredients()
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
                        
                        if filteredRecipes.isEmpty && searchQuery.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                            Text("No results found. \n Try another search query")
                        } else {
                            RecipeList(
                                recipes: $filteredRecipes.isEmpty && searchQuery.trimmingCharacters(in: .whitespacesAndNewlines) == ""
                                ? $recipes
                                : $filteredRecipes,
                                isTabBarHidden: $isTabBarHidden
                            )
                        }
                    }
                    
                }
            }
            .navigationBarTitle("Meal Search", displayMode: .large)
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
        let result = await APIHandler.shared.searchRecipes(from: pantryIngredients, number: 10)
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

}

//#Preview {
//    SearchView(isTabBarHidden: .constant(false), selectedTab: .constant(1))
//        .environmentObject(IngredientTabStore())
//}

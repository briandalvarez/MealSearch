//
//  SearchView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI

struct SearchView: View {
    @Binding var isTabBarHidden: Bool
    @EnvironmentObject var tabStore: IngredientTabStore
    
    @State private var recipes: [RecipeModel] = []
    @State private var isLoading = false
    
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
                    .padding(.top, 120)
                } else if recipes.isEmpty {
                    let pantry = tabStore.tabs[0].list.ingredients
                    
                    VStack(spacing: 16) {
                        if pantry.isEmpty {
                            Text("Add Ingredients to My Pantry to Find Recipes")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                            
                            Image(systemName: "archivebox")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.7))
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
                    .padding(.top, 130)
                }
                else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(recipes) { recipe in
                                NavigationLink {
                                    RecipeDetailsView(
                                        recipeSummary: recipe,
                                        details: MockRecipeDetails.sample,
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
            .navigationBarTitle("Meal Search", displayMode: .large)
        }
        .task {
            await loadRecipesFromAPI()
        }
    }

    private func loadRecipesFromAPI() async {
        let pantryIngredients = tabStore.tabs[0].list.ingredients
        
        if pantryIngredients.isEmpty {
            recipes = []
            isLoading = false
            return
        }
        
        isLoading = true
        
        let result = await APIHandler.shared.searchRecipes(from: pantryIngredients, number: 20)
        
        recipes = result
        isLoading = false
    }
}

#Preview {
    SearchView(isTabBarHidden: .constant(false))
        .environmentObject(IngredientTabStore())
}

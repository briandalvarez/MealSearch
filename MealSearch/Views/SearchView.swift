//
//  SearchView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI

struct SearchView: View {
    @State private var recipes: [RecipeModel] = MockRecipes.all
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundCream")
                    .ignoresSafeArea()
                
                if recipes.isEmpty {
                    VStack(spacing: 16) {
                        Text("No Recipes Found")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 24)
                        
                        Image(systemName: "exclamationmark.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.7))
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(recipes) { recipe in
                                NavigationLink {
                                    Text(recipe.title)
                                        .font(.title2)
                                        .padding()
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
    }
}

#Preview {
    SearchView()
}

//
//  SearchView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI

struct SearchView: View {
    @State private var recipes: [RecipeSummary] = MockRecipes.all
    
    var body: some View {
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
                            RecipeCardView(recipe: recipe)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}

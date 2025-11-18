//
//  RecipeCardView.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/14/25.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: RecipeSummary
    
    var body: some View {
        HStack(spacing: 12) {
            
            AsyncImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.caption)
                                .foregroundColor(.gray)
                        )
            }
            .frame(width: 80, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .layoutPriority(1)
                
                HStack(spacing: 10) {
                    Label("\(recipe.readyInMinutes) min", systemImage: "clock")
                    Label("\(recipe.servings) servings", systemImage: "person.2")
                    }
                .font(.caption)
                .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    RecipeCardView(
        recipe: RecipeSummary(
            id: 9003,
            title: "Apple Strudel",
            image: "https://img.spoonacular.com/recipes/73420-312x231.jpg",
            readyInMinutes: 45,
            servings: 4,
            usedIngredientCount: 3,
            missedIngredientCount: 1
        )
    )
}

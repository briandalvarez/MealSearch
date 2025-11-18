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
                    .frame(maxWidth: 180, alignment: .leading)
                
                HStack(spacing: 10) {
                    if recipe.readyInMinutes >= 0 {
                        Label("\(recipe.readyInMinutes) min", systemImage: "clock")
                    }
                    if recipe.servings >= 0 {
                        Label("\(recipe.servings) serving\(recipe.servings == 1 ? "" : "s")", systemImage: "person.2")
                    }
                    }
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: 187, alignment: .leading)
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        .overlay(
            VStack {
                FavoriteButton()
                Spacer()
                IngredientWheel()
            }
                .padding(.vertical, 10)
                .padding(.trailing, 16),
            alignment: .topTrailing
        )
    }
}

struct FavoriteButton: View {
    @State private var isFavorite = false
    
    var body: some View {
        Button {
            isFavorite.toggle()
        } label: {
            Image(systemName: isFavorite ? "star.circle.fill" : "star.circle")
                .foregroundColor(isFavorite ? .red : .gray)
                .font(.system(size: 40, weight: .light))
                .frame(width: 44, height: 44)
        }
    }
}

// This is just a placeholder for the real ingredient wheel this needs to be updated later
struct IngredientWheel: View {
    var body: some View {
        Button {
            // Will later direct the user to the ingredient list
        } label: {
            Image(systemName: "ring")
                .foregroundColor(.gray)
                .font(.system(size: 34, weight: .light))
                .frame(width: 44, height: 44)
        }
    }
}

#Preview {
    RecipeCardView(
        recipe: RecipeSummary(
            id: 9003,
            title: "Quinoa and Chickpea Salad with Sun-Dried Tomatoes and Dried Cherries",
            image: "https://img.spoonacular.com/recipes/716004-312x231.jpg",
            readyInMinutes: 1500,
            servings: 100,
            usedIngredientCount: 3,
            missedIngredientCount: 5
        )
    )
    .padding(.horizontal, 16)
}

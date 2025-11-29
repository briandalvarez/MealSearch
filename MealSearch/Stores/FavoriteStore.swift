//
//  FavoriteStore.swift
//  MealSearch
//
//  Created by br-zee on 11/28/25.
//

import Foundation
import SwiftData

class FavoriteStore: ObservableObject {
    @Published var favorites: [RecipeModel] = []
    
    func toggle(_ recipe: RecipeModel, recipeStore: RecipeStore, context: ModelContext) -> Void {
        if self.contains(recipe) {
            self.remove(recipe)
        } else {
            self.add(recipe)
        }
        recipeStore.setFavoritedRecipes(recipes: favorites, context: context)
    }
    
    func contains(_ recipe: RecipeModel) -> Bool {
        return favorites.contains {
            $0.id == recipe.id
        }
    }
    
    private func add(_ recipe: RecipeModel) -> Void {
        favorites.append(recipe)
    }
    
    private func remove(_ recipe: RecipeModel) -> Void {
        favorites = favorites.filter {
            $0.id != recipe.id
        }
    }
}

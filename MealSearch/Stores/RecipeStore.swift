//
//  IngredientStore.swift
//  MealSearch
//
//  Created by br-zee on 11/28/25.
//

import Foundation
import SwiftData

@Model
class RecipeStore {
    @Relationship
    var fetchedRecipes: [RecipeModel]
    
    @Relationship
    var favoritedRecipes: [RecipeModel]
    
    init() {
        self.fetchedRecipes = []
        self.favoritedRecipes = []
    }
    
    func setFetchedRecipes(recipes: [RecipeModel], context: ModelContext) {
        // Delete old objects in context
        for old in fetchedRecipes {
            context.delete(old)
        }

        // Insert new objects
        recipes.forEach { context.insert($0) }

        fetchedRecipes = recipes

        try? context.save()
    }


    
    func setFavoritedRecipes(recipes: [RecipeModel], context: ModelContext) {
        // Delete old objects in context
        for old in favoritedRecipes {
            context.delete(old)
        }

        // Insert new objects
        recipes.forEach { context.insert($0) }

        favoritedRecipes = recipes

        try? context.save()
    }
}

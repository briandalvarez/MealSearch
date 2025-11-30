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
        // Save the IDs of favorite recipes to preserve them
        let favoritedIDs = Set(favoritedRecipes.map {$0.id})
        
        // Delete old objects in context if they have not been favorited
        for old in fetchedRecipes {
            if !favoritedIDs.contains(old.id) {
                context.delete(old)
            }
        }

        // Insert new objects, but skip if already favorited
        for newRecipe in recipes {
            if !favoritedIDs.contains(newRecipe.id) {
                context.insert(newRecipe)
            }
        }

        // Update array for fetched recipes
        // Use the favorited instance of a recipe object if it exists, if not use a new one
        fetchedRecipes.removeAll()
        
        for newRecipe in recipes {
            var recipeToAdd = newRecipe
            
            for favorited in favoritedRecipes {
                if favorited.id == newRecipe.id {
                    recipeToAdd = favorited
                    break
                }
            }
            fetchedRecipes.append(recipeToAdd)
        }

        try? context.save()
    }


    
    func setFavoritedRecipes(recipes: [RecipeModel], context: ModelContext) {
        // Update favorites array 
        favoritedRecipes = recipes
        try? context.save()
    }
}

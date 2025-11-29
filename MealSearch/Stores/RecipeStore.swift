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
    var fetchedRecipes: [RecipeModel] = []
    var favoritedRecipes: [RecipeModel] = []
    
    init(fetched: [RecipeModel] = [], favorites: [RecipeModel] = []) {
        self.fetchedRecipes = fetched
        self.favoritedRecipes = favorites
    }
    
    func setFetchedRecipes(recipes: [RecipeModel], context: ModelContext) {
        fetchedRecipes.removeAll()
        recipes.forEach {
            recipe in
            fetchedRecipes.append(recipe)
        }
                
        do { try context.save() }
        catch { print("Save error:", error) }
    }
    
    func setFavoritedRecipes(recipes: [RecipeModel], context: ModelContext) {
        favoritedRecipes.removeAll()
        recipes.forEach {
            recipe in
            favoritedRecipes.append(recipe)
        }
        
        do { try context.save() }
        catch { print("Save error:", error) }
    }
}

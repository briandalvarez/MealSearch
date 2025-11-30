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
    @Relationship(deleteRule: .cascade)
    var fetchedRecipes: [RecipeModel]
    
    @Relationship(deleteRule: .cascade)
    var favoritedRecipes: [RecipeModel]
    
    init() {
        self.fetchedRecipes = []
        self.favoritedRecipes = []
    }
    
    func setFetchedRecipes(recipes: [RecipeModel], context: ModelContext) {
        while !fetchedRecipes.isEmpty {
            fetchedRecipes.removeLast()
        }
        
        recipes.forEach {
            recipe in
            fetchedRecipes.append(recipe)
        }
                
        do { try context.save() }
        catch { print("Save error:", error) }
    }
    
    func setFavoritedRecipes(recipes: [RecipeModel], context: ModelContext) {
        while !favoritedRecipes.isEmpty {
            favoritedRecipes.removeLast()
        }
        
        recipes.forEach {
            recipe in
            favoritedRecipes.append(recipe)
        }
        
        do { try context.save() }
        catch { print("Save error:", error) }
    }
}

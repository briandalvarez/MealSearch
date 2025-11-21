//
//  RecipeSummary.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/12/25.
//

// This file defines the data we use to represent a single recipe returned by the spoonacular API

import Foundation

// Decodable protocol converts JSON to Swift objects
// Identifiable protocol uses the id property below to give each recipe a unique identity
// Hashable protocol allows recipes to be stored in sets so they can easily be compared or updated

struct RecipeModel: Decodable, Identifiable, Hashable {
    // Required details for each recipe
    // Based on the spoonacular API's JSON key-value pair names in documentation
    let id: Int
    let title: String
    let image: String?
    
    let readyInMinutes: Int?
    let servings: Int? 
    
    let usedIngredientCount: Int?
    let missedIngredientCount: Int?
    
    // Calculate the percentage of ingredients the user already has for the ingredient wheel
    var matchRatio: Double {
        let used = usedIngredientCount ?? 0
        let missed = missedIngredientCount ?? 0
        let total = used + missed
        guard total > 0 else { return 0 }
        return Double(used) / Double(total)
    }
    
    var matchPercent:Int {
        Int((matchRatio * 100).rounded())
    }
}

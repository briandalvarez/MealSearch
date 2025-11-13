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

struct RecipeSummary: Decodable, Identifiable, Hashable {
    // Required details for each recipe
    // Based on the spoonacular API's JSON key-value pairs in documentation
    let id: Int
    let title: String
    let image: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    
    // Optional details that may not always be returned by the "Search Recipes" endpoint we are using
    let readyInMinutes: Int?
    let servings: Int?
    let aggregateLikes: Int?
    
    // Calculate the percentage of ingredients the user already has for the ingredient wheel
    var matchRatio: Double {
        let total = usedIngredientCount + missedIngredientCount
        guard total > 0 else { return 0 }
        return Double(usedIngredientCount) / Double(total)
    }
    
    var matchPercent:Int {
        Int((matchRatio * 100).rounded())
    }
}

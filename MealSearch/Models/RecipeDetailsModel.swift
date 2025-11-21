//
//  RecipeDetail.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/18/25.
//

import Foundation

struct RecipeDetailsModel: Decodable, Identifiable {
    let id: Int
    let title: String
    let image: String?
    let readyInMinutes: Int?
    let servings: Int?
    
    let extendedIngredients: [IngredientModel]
    
    let summary: String?
    let instructions: [String]
    
}

//
//  RecipeDetail.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/18/25.
//

import Foundation

struct RecipeDetails: Decodable, Identifiable {
    let id: Int
    let title: String
    let image: String?
    let summary: String?
    let readyInMinutes: Int?
    let servings: Int?
    let extendedIngredients: [IngredientModel]
    let instructions: String?
}

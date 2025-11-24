//
//  IngredientSummary.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/17/25.
//

import Foundation

struct IngredientModel: Decodable, Identifiable, Hashable {
    let id: Int
    var name: String
    var original: String = ""
    let image: String?
    
    var formattedImage: String {
        if let img = image {
            return "https://img.spoonacular.com/ingredients_100x100/" + img
        }
        return "https://via.placeholder.com/100"
    }

    var amount: Double? = 0.0
    var unit: String? = ""
    let aisle: String?
}

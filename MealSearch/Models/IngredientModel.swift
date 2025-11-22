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
    let image: String
    
    var formattedImage: String {
        !image.contains("spoonacular")
            ? "https://img.spoonacular.com/ingredients_100x100/\(image)"
            : image
    }

    var amount: Double? = 0.0
    var unit: String? = ""
    let aisle: String
}

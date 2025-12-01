//
//  IngredientSummary.swift
//  MealSearch
//


import Foundation

// Stores various ingredient information
struct IngredientModel: Codable, Identifiable, Hashable {
    let id: Int
    var name: String
    var original: String = ""
    let image: String?

    
    // Returns a complete URL for Spoonacular ingredient images.
    // If Spoonacular returns only the filename, this prefixes the correct base path.
    // If the returned value is already a full URL, it is used as-is.
    var formattedImage: String {
        if let img = image {
            if img.contains("spoonacular") {
                return img
            } else {
                return "https://img.spoonacular.com/ingredients_100x100/" + img
            }
        }
        return "https://via.placeholder.com/100"
    }

    var amount: Double? = 0.0
    var unit: String? = ""
    let aisle: String?
}

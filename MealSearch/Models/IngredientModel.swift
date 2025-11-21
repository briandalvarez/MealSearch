//
//  IngredientSummary.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/17/25.
//

import Foundation

struct IngredientModel: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let original: String
    let image: String?
    
    let amount: Double?
    let unit: String?
    let aisle: String?
}

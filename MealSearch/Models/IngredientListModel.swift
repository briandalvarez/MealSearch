//
//  IngredientListModel.swift
//  MealSearch
//
//  Created by br-zee on 11/21/25.
//

import Foundation

struct IngredientListModel: Identifiable {
    let id: Int
    var ingredients: [IngredientModel]
    
    mutating func addIngredient(_ ingredient: IngredientModel) -> Void {
        ingredients.append(ingredient)
    }
    
    mutating func removeIngredient(_ ingredient: IngredientModel) -> Void {
        ingredients.removeAll {
            $0.id == ingredient.id
        }
    }
}

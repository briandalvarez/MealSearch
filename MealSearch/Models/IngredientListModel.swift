//
//  IngredientListModel.swift
//  MealSearch
//
//  Created by br-zee on 11/21/25.
//

import Foundation
import SwiftData

@Model
class IngredientListModel: Identifiable {    
    @Attribute(.unique) var id: Int
    var ingredients: [IngredientModel]
    
    init(id: Int, ingredients: [IngredientModel] = []) {
        self.id = id
        self.ingredients = ingredients
    }
    
    func addIngredient(_ ingredient: IngredientModel) {
        ingredients.append(ingredient)
    }
    
    func removeIngredient(_ ingredient: IngredientModel) {
        ingredients.removeAll { $0.id == ingredient.id }
    }
}

//struct IngredientListModel: Identifiable {
//    let id: Int
//    var ingredients: [IngredientModel]
//
//    mutating func addIngredient(_ ingredient: IngredientModel) -> Void {
//        ingredients.append(ingredient)
//    }
//
//    mutating func removeIngredient(_ ingredient: IngredientModel) -> Void {
//        ingredients.removeAll {
//            $0.id == ingredient.id
//        }
//    }
//}


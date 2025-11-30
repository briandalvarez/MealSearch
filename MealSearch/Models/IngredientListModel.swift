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
    var ingredientsData: Data
        
    var ingredients: [IngredientModel] {
        get {
            (try? JSONDecoder().decode([IngredientModel].self, from: ingredientsData)) ?? []
        }
        set {
            ingredientsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
    
    init(id: Int, ingredients: [IngredientModel] = []) {
        self.id = id
        self.ingredientsData =
            (try? JSONEncoder().encode(ingredients)) ?? Data()
    }
    
    func addIngredient(_ ingredient: IngredientModel) {
        var copy = ingredients
        copy.append(ingredient)
        ingredients = copy
    }

    func removeIngredient(_ ingredient: IngredientModel) {
        var copy = ingredients
        copy.removeAll { $0.id == ingredient.id }
        ingredients = copy
    }
}


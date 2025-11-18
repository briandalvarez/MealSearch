//
//  MockIngredients.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/17/25.
//

import Foundation

enum MockIngredients {
    
    static let pantry: [IngredientSummary] = [
        IngredientSummary(
            id: 9003,
            name: "apple",
            original: "4 apples",
            image: "https://img.spoonacular.com/ingredients_100x100/apple.jpg",
            amount: 4,
            unit: "pieces",
            aisle: "Produce"
        ),
        IngredientSummary(
            id: 20080,
            name: "whole wheat flour",
            original: "1 kg whole wheat flour",
            image: "https://img.spoonacular.com/ingredients_100x100/flour.png",
            amount: 1.0,
            unit: "kg",
            aisle: "Baking"
        ),
        IngredientSummary(
            id: 1123,
            name: "egg",
            original: "1 dozen eggs",
            image: "https://img.spoonacular.com/ingredients_100x100/egg.png",
            amount: 12,
            unit: "",
            aisle: "Milk, Eggs, Other Dairy"
        ),
        IngredientSummary(
            id: 19296,
            name: "honey",
            original: "1/2 cup honey",
            image: "https://img.spoonacular.com/ingredients_100x100/honey.png",
            amount: 0.5,
            unit: "cup",
            aisle: "Nut butters, Jams, and Honey"
        ),
        IngredientSummary(
            id: 2047,
            name: "salt",
            original: "1 tablespoon salt",
            image: "https://img.spoonacular.com/ingredients_100x100/salt.jpg",
            amount: 1.0,
            unit: "tbsp",
            aisle: "Spices and Seasonings"
        )
    ]
    
    static let sample: IngredientSummary = pantry[0]
}

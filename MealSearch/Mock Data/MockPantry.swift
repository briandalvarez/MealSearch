//
//  MockPantry.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/23/25.
//

import Foundation

struct MockPantry {
    static let ingredients: [IngredientModel] = [
        IngredientModel(
            id: 1123,
            name: "egg",
            original: "1 egg",
            image: "egg.png",
            amount: 1.0,
            unit: "",
            aisle: "Dairy"
        ),
        
        IngredientModel(
            id: 1001,
            name: "butter",
            original: "2 tbsp butter",
            image: "butter-sliced.jpg",
            amount: 2.0,
            unit: "tbsp",
            aisle: "Dairy"
        ),
        
        IngredientModel(
            id: 20081,
            name: "flour",
            original: "1 cup flour",
            image: "flour.png",
            amount: 1.0,
            unit: "cup",
            aisle: "Baking"
        ),
        
        IngredientModel(
            id: 19335,
            name: "sugar",
            original: "1/2 cup sugar",
            image: "sugar-in-bowl.png",
            amount: 0.5,
            unit: "cup",
            aisle: "Baking"
        ),
        
        IngredientModel(
            id: 9003,
            name: "apple",
            original: "1 apple",
            image: "apple.jpg",
            amount: 1.0,
            unit: "",
            aisle: "Produce"
        )
    ]
}

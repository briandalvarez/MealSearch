//
//  MockIngredients.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/17/25.
//

import Foundation

enum MockIngredients {
    
    static let pantry: [IngredientModel] = [
        IngredientModel(
            id: 9003,
            name: "apple",
            original: "4 apples",
            image: "https://img.spoonacular.com/ingredients_100x100/apple.jpg",
            amount: 4,
            unit: "pieces",
            aisle: "Produce"
        ),
        IngredientModel(
            id: 20080,
            name: "whole wheat flour",
            original: "1 kg whole wheat flour",
            image: "https://img.spoonacular.com/ingredients_100x100/flour.png",
            amount: 1.0,
            unit: "kg",
            aisle: "Baking"
        ),
        IngredientModel(
            id: 1123,
            name: "egg",
            original: "1 dozen eggs",
            image: "https://img.spoonacular.com/ingredients_100x100/egg.png",
            amount: 12,
            unit: "",
            aisle: "Milk, Eggs, Other Dairy"
        ),
        IngredientModel(
            id: 19296,
            name: "honey",
            original: "1/2 cup honey",
            image: "https://img.spoonacular.com/ingredients_100x100/honey.png",
            amount: 0.5,
            unit: "cup",
            aisle: "Nut butters, Jams, and Honey"
        ),
        IngredientModel(
            id: 2047,
            name: "salt",
            original: "1 tablespoon salt",
            image: "https://img.spoonacular.com/ingredients_100x100/salt.jpg",
            amount: 1.0,
            unit: "tbsp",
            aisle: "Spices and Seasonings"
        ),
        
        // Ingredients fetched from ingredient search endpoint
        IngredientModel(
            id: 19335,
            name: "sugar",
            image: "sugar-in-bowl.png",
            aisle: "Baking",
        ),
        IngredientModel(
            id: 4582,
            name: "cooking oil",
            image: "vegetable-oil.jpg",
            aisle: "Oil, Vinegar, Salad Dressing"
        ),
        IngredientModel(
            id: 20444,
            name: "rice",
            image: "uncooked-white-rice.png",
            aisle: "Pasta and Rice"
        ),
        IngredientModel(
            id: 1041009,
            name: "cheese",
            image: "cheddar-cheese.png",
            aisle: "Cheese"
        ),
        IngredientModel(
            id: 1077,
            name: "milk",
            image: "milk.png",
            aisle: "Milk, Eggs, Other Dairy"
        )
    ]
    
    static let sample: IngredientModel = pantry[0]
}

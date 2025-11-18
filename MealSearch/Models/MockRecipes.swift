//
//  MockData.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/14/25.
//

import Foundation

enum MockRecipes {
    
    static let sample: RecipeSummary = RecipeSummary(
        id: 1095878,
        title: "Muesli Cookies",
        image: "https://img.spoonacular.com/recipes/1095878-312x231.jpg",
        readyInMinutes: 30,
        servings: 8,
        usedIngredientCount: 2,
        missedIngredientCount: 11
    )
    
    static let all: [RecipeSummary] = [
        RecipeSummary(
            id: 1095878,
            title: "Muesli Cookies",
            image: "https://img.spoonacular.com/recipes/1095878-312x231.jpg",
            readyInMinutes: 30,
            servings: 8,
            usedIngredientCount: 2,
            missedIngredientCount: 11
        ),
        RecipeSummary(
            id: 641057,
            title: "Curried Butternut Squash and Apple Soup",
            image: "https://img.spoonacular.com/recipes/641057-312x231.jpg",
            readyInMinutes: 45,
            servings: 1,
            usedIngredientCount: 0,
            missedIngredientCount: 8
        ),
        RecipeSummary(
            id: 660266,
            title: "Slow Cooked Corned Beef and Cabbage",
            image: "https://img.spoonacular.com/recipes/660266-312x231.jpg",
            readyInMinutes: 500,
            servings: 10,
            usedIngredientCount: 1,
            missedIngredientCount: 6
        ),
        RecipeSummary(
            id: 640318,
            title: "Crab Salad Stuffed Pita Pockets",
            image: "https://img.spoonacular.com/recipes/640318-312x231.jpg",
            readyInMinutes: 25,
            servings: 2,
            usedIngredientCount: 1,  
            missedIngredientCount: 7
        ),
        RecipeSummary(
            id: 638604,
            title: "Chilled Swiss Oatmeal",
            image: "https://img.spoonacular.com/recipes/638604-312x231.jpg",
            readyInMinutes: 10,
            servings: 1,
            usedIngredientCount: 3,
            missedIngredientCount: 2
        )
    ]
}

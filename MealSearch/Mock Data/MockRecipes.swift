//
//  MockData.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/14/25.
//

import Foundation

enum MockRecipes {
    
    static let sample: RecipeModel = RecipeModel(
        id: 1095878,
        title: "Muesli Cookies",
        image: "https://img.spoonacular.com/recipes/1095878-312x231.jpg",
        readyInMinutes: 30,
        servings: 8,
        usedIngredientCount: 2,
        missedIngredientCount: 11,
        summary: "Heart Shaped Egg & Cheese Nibbles is a <b>dairy free</b> side dish. This recipe serves 8. One serving contains <b>212 calories</b>, <b>13g of protein</b>, and <b>12g of fat</b>. For <b>78 cents per serving</b>, this recipe <b>covers 12%</b> of your daily requirements of vitamins and minerals. If you have eggs, american cheese, heart shaped cookie cutter, and a few other ingredients on hand, you can make it. Not a lot of people made this recipe, and 1 would say it hit the spot. <b>valentin day</b> will be even more special with this recipe. It is brought to you by Foodista. From preparation to the plate, this recipe takes approximately <b>45 minutes</b>. With a spoonacular <b>score of 37%</b>, this dish is rather bad. Users who liked this recipe also liked <a href=\"https://spoonacular.com/recipes/heart-shaped-cheese-scones-384681\">Heart-Shaped Cheese Scones</a>, <a href=\"https://spoonacular.com/recipes/heart-shaped-strawberry-cream-cheese-breakfast-pastries-714640\">Heart-Shaped Strawberry Cream Cheese Breakfast Pastries</a>, and <a href=\"https://spoonacular.com/recipes/heart-shaped-pavlova-1178609\">Heart Shaped Pavlova</a>.",
        healthScore: 4.0,
        analyzedInstructions: [MealSearch.InstructionGroup(name: Optional(""), steps: [MealSearch.InstructionStep(number: 1, step: "Preheat oven to 350 degrees."), MealSearch.InstructionStep(number: 2, step: "Grease 6 jumbo muffin tin."), MealSearch.InstructionStep(number: 3, step: "Combine cake mix milk, vanilla and oil."), MealSearch.InstructionStep(number: 4, step: "Mix till combined."), MealSearch.InstructionStep(number: 5, step: "Add eggs beat till mixed well."), MealSearch.InstructionStep(number: 6, step: "Bake for 18- 21 min"), MealSearch.InstructionStep(number: 7, step: "After cooking cupcakes use a spoon and cut out enough area to insert Cadbury egg."), MealSearch.InstructionStep(number: 8, step: "Making sure the smaller part of the egg is facing up."), MealSearch.InstructionStep(number: 9, step: "Frost the cupcake hiding the Cadbury egg.")])],
        extendedIngredients: [MealSearch.IngredientModel(id: 1123, name: "eggs", original: "4 eggs", image: Optional("egg.png"), amount: Optional(4.0), unit: Optional(""), aisle: Optional("Milk, Eggs, Other Dairy")), MealSearch.IngredientModel(id: 1123, name: "cadbury eggs", original: "6 Cadbury eggs.", image: Optional("egg.png"), amount: Optional(6.0), unit: Optional(""), aisle: Optional("Milk, Eggs, Other Dairy")), MealSearch.IngredientModel(id: 1077, name: "milk", original: "1 cup of milk,", image: Optional("milk.png"), amount: Optional(1.0), unit: Optional("cup"), aisle: Optional("Milk, Eggs, Other Dairy")), MealSearch.IngredientModel(id: 4582, name: "oil", original: "1/3 cup of oil", image: Optional("vegetable-oil.jpg"), amount: Optional(0.33333334), unit: Optional("cup"), aisle: Optional("Oil, Vinegar, Salad Dressing")), MealSearch.IngredientModel(id: 1052050, name: "vanilla", original: "1 tsp of vanilla,", image: Optional("vanilla.jpg"), amount: Optional(1.0), unit: Optional("tsp"), aisle: Optional("Baking"))]
    )
    
    static let all: [RecipeModel] = [
        RecipeModel (
            id: 1095878,
            title: "Asparagus and Pea Soup: Real Convenience Food",
            image: "https://img.spoonacular.com/recipes/1095878-312x231.jpg",
            readyInMinutes: 30,
            servings: 8,
            usedIngredientCount: 2,
            missedIngredientCount: 11,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 641057,
            title: "Curried Butternut Squash and Apple Soup",
            image: "https://img.spoonacular.com/recipes/641057-312x231.jpg",
            readyInMinutes: 45,
            servings: 1,
            usedIngredientCount: 0,
            missedIngredientCount: 8,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 660266,
            title: "Slow Cooked Corned Beef and Cabbage",
            image: "https://img.spoonacular.com/recipes/660266-312x231.jpg",
            readyInMinutes: 500,
            servings: 10,
            usedIngredientCount: 1,
            missedIngredientCount: 6,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 640318,
            title: "Crab Salad Stuffed Pita Pockets",
            image: "https://img.spoonacular.com/recipes/640318-312x231.jpg",
            readyInMinutes: 25,
            servings: 2,
            usedIngredientCount: 1,  
            missedIngredientCount: 7,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 638604,
            title: "Chilled Swiss Oatmeal",
            image: "https://img.spoonacular.com/recipes/638604-312x231.jpg",
            readyInMinutes: 10,
            servings: 1,
            usedIngredientCount: 3,
            missedIngredientCount: 2,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 715415,
            title: "Red Lentil Soup with Chicken and Turnips",
            image: "https://img.spoonacular.com/recipes/715415-312x231.jpg",
            readyInMinutes: 55,
            servings: 8,
            usedIngredientCount: 3,
            missedIngredientCount: 5,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 716406,
            title: "Asparagus and Pea Soup: Real Convenience Food",
            image: "https://img.spoonacular.com/recipes/716406-312x231.jpg",
            readyInMinutes: 20,
            servings: 2,
            usedIngredientCount: 2,
            missedIngredientCount: 4,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 644387,
            title: "Garlicky Kale",
            image: "https://img.spoonacular.com/recipes/644387-312x231.jpg",
            readyInMinutes: 45,
            servings: 2,
            usedIngredientCount: 1,
            missedIngredientCount: 3,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 715446,
            title: "Slow Cooker Beef Stew",
            image: "https://img.spoonacular.com/recipes/715446-312x231.jpg",
            readyInMinutes: 490,
            servings: 6,
            usedIngredientCount: 4,
            missedIngredientCount: 6,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 782601,
            title: "Red Kidney Bean Jambalaya",
            image: "https://img.spoonacular.com/recipes/782601-312x231.jpg",
            readyInMinutes: 45,
            servings: 6,
            usedIngredientCount: 3,
            missedIngredientCount: 5,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 716426,
            title: "Cauliflower, Brown Rice, and Vegetable Fried Rice",
            image: "https://img.spoonacular.com/recipes/716426-312x231.jpg",
            readyInMinutes: 30,
            servings: 8,
            usedIngredientCount: 4,
            missedIngredientCount: 5,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 716004,
            title: "Quinoa and Chickpea Salad with Sun-Dried Tomatoes and Dried Cherries",
            image: "https://img.spoonacular.com/recipes/716004-312x231.jpg",
            readyInMinutes: 45,
            servings: 6,
            usedIngredientCount: 3,
            missedIngredientCount: 5,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel(
            id: 716627,
            title: "Easy Homemade Rice and Beans",
            image: "https://img.spoonacular.com/recipes/716627-312x231.jpg",
            readyInMinutes: 35,
            servings: 2,
            usedIngredientCount: 2,
            missedIngredientCount: 4,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel(
            id: 664147,
            title: "Tuscan White Bean Soup with Olive Oil and Rosemary",
            image: "https://img.spoonacular.com/recipes/664147-312x231.jpg",
            readyInMinutes: 45,
            servings: 6,
            usedIngredientCount: 2,
            missedIngredientCount: 4,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        ),
        RecipeModel (
            id: 640941,
            title: "Crunchy Brussels Sprouts Side Dish",
            image: "https://img.spoonacular.com/recipes/640941-312x231.jpg",
            readyInMinutes: 30,
            servings: 4,
            usedIngredientCount: 1,
            missedIngredientCount: 3,
            summary: "",
            healthScore: 0.0,
            analyzedInstructions: [],
            extendedIngredients: []

        )
    ]
}

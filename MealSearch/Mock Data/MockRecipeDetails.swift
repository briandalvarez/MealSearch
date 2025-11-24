//
//  MockRecipeDetails.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/18/25.
//

import Foundation

struct MockRecipeDetails {

    static let sample = RecipeDetailsModel(
        id: 715415,
        title: "Red Lentil Soup with Chicken and Turnips",
        image: "https://img.spoonacular.com/recipes/715415-556x370.jpg",
        readyInMinutes: 55,
        servings: 8,
        
        extendedIngredients: [
            IngredientModel(
                id: 11124,
                name: "Carrots",
                original: "3 medium carrots, peeled and diced",
                image: "sliced-carrot.png",
                amount: 3.0,
                unit: "medium",
                aisle: "Produce"
            ),
            IngredientModel(
                id: 11143,
                name: "Celery Stalks",
                original: "3 celery stalks, diced",
                image: "celery.jpg",
                amount: 3.0,
                unit: "",
                aisle: "Produce"
            ),
            IngredientModel(
                id: 11282,
                name: "Onion",
                original: "1 medium yellow onion, diced",
                image: "brown-onion.png",
                amount: 1.0,
                unit: "medium",
                aisle: "Produce"
            ),
            IngredientModel(
                id: 11215,
                name: "Garlic",
                original: "6 cloves garlic, minced",
                image: "garlic.png",
                amount: 6.0,
                unit: "cloves",
                aisle: "Produce"
            )
        ],
        summary: "Red lentil soup with chicken and turnips is a hearty, rustic dish made by simmering tender red lentils with chunks of chicken and mild, slightly sweet turnips. As the lentils cook, they break down into a smooth, velvety base that thickens the broth, while the chicken adds richness and savory depth. The turnips soften into the soup, giving it a gentle earthiness and a subtle sweetness that balances the flavors. Warm spices, onions, garlic, or herbs are often added, creating a comforting, nourishing bowl that’s both filling and wholesome.",
        instructions: [
            "Heat olive oil over medium heat in a large pot.",
            "Add carrots, celery, and onion. Cook for 8–10 minutes.",
            "Add garlic and cook for 2 minutes.",
            "Add tomatoes, lentils, and turnip. Add stock and bring to a boil.",
            "Reduce heat and simmer for 20 minutes until the lentils soften.",
            "Stir in shredded chicken and parsley. Cook 5 more minutes.",
            "Serve hot and enjoy!"
        ],
        healthScore: 85.0
    )
}

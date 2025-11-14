//
//  APITest.Swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/12/25.
//
// This file is just to see test if we can actually retrieve the data we need from the API
// Not a part of our project 

import Foundation

// Decode recipe card fields
struct RecipeTest: Decodable {
    let id: Int
    let title: String
    let readyInMinutes: Int?
    let servings: Int?
    let aggregateLikes: Int?
}

// Function to test if API response works
func testRecipeInformation() async {
    let apiKey = "9636eb8b5e6943c58a7d7836c73c9410"
    // Returning ten recipes for pasta
    let urlString = "https://api.spoonacular.com/recipes/complexSearch?query=pasta&number=10&addRecipeInformation=true&fillIngredients=true&apiKey=\(apiKey)"

    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    do {
        // Fetch data from spoonacular API
        let (data, _) = try await URLSession.shared.data(from: url)

        // Decode JSON into a dictionary
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let dict = json as? [String: Any], let results = dict["results"] as? [[String: Any]] {
            print("Results count: \(results.count)")
            for recipe in results {
                let title = recipe["title"] ?? "N/A"
                let ready = recipe["readyInMinutes"] ?? "—"
                let servings = recipe["servings"] ?? "—"
                let likes = recipe["aggregateLikes"] ?? "—"
                print("\(title)\n  \(ready) min | Servings: \(servings) | Likes: \(likes)\n")
            }
        }

    } catch {
        print("Error fetching data: \(error.localizedDescription)")
    }
}

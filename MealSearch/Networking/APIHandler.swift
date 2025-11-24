//
//  RecipeAPI.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/23/25.
//

import Foundation

struct ComplexSearchResponse: Decodable {
    let results: [RecipeModel]
    let offset: Int?
    let number: Int?
    let totalResults: Int?
}

class APIHandler {
    static let shared = APIHandler()
    private init() {}
    
    private let apiKey = "9636eb8b5e6943c58a7d7836c73c9410"
    private let baseURL = URL(string: "https://api.spoonacular.com")!
    
    // meal search screen
    func searchRecipes(ingredients: [String], number: Int = 20) async -> [RecipeModel] {
        guard var components = URLComponents(url: baseURL.appendingPathComponent("/recipes/complexSearch"),
                                             resolvingAgainstBaseURL: false
        ) else {
            print("Invalid URL")
            return []
        }
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "number", value: String(number)),
            URLQueryItem(name: "addRecipeInformation", value: "true"),
            URLQueryItem(name: "fillIngredients", value: "true"),
            URLQueryItem(name: "sort", value: "max-used-ingredients")
        ]
        
        if !ingredients.isEmpty {
            let joined = ingredients.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "includeIngredients", value: joined))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            print("Invalid URL")
            return []
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(ComplexSearchResponse.self, from: data)
            return decoded.results
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return[]
        }
    }
    
    func searchRecipes(from pantry: [IngredientModel], number: Int = 20) async -> [RecipeModel] {
        let ingredientNames = pantry.map { $0.name }
        return await searchRecipes(ingredients: ingredientNames, number: number)
    }
    
    // recipe details screen
    
    func fetchRecipeDetails(id: Int) async -> RecipeDetailsModel? {
        guard var components = URLComponents(url: baseURL.appendingPathComponent("/recipes/\(id)/information"),
                                             resolvingAgainstBaseURL: false
        ) else {
            print("Invalid URL")
            return nil
        }
        
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "includeNutrition", value: "false")
        ]
        
        guard let url = components.url else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let(data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(RecipeDetailsModel.self, from: data)
            return decoded
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
    
    // ingredients screen
    
    func fetchIngredients(of ingredientName: String) async -> [IngredientModel] {
        var ingredients: [IngredientModel] = []
        
        let urlString = "https://api.spoonacular.com/food/ingredients/search?query=\(ingredientName)&number=5&metaInformation=true&&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return []
        }
        do {
            // Fetch data from spoonacular API
            let (data, _) = try await URLSession.shared.data(from: url)

            // Decode JSON into a dictionary
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let dict = json as? [String: Any], let results = dict["results"] as? [[String: Any]] {
                print("Results count: \(results.count)")
                for ingredient in results {
                   guard let id = ingredient["id"] as? Int,
                         let name = ingredient["name"] as? String else{
                       continue
                   }
                    let image = ingredient["image"] as? String
                    let aisle = ingredient["aisle"] as? String

                    
                    let ingredientModel = IngredientModel(
                        id: id,
                        name: name,
                        original: "",
                        image: image ?? "",
                        amount: nil,
                        unit: nil,
                        aisle: aisle
                    )
                    ingredients.append(ingredientModel)
                }
            }

        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
        return ingredients
    }
    
    
    
}

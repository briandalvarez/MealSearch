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
    
    private func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    // meal search screen
    func searchRecipes(ingredients: [String], number: Int = 10, offset: Int = 0, query: String = "", broad: Bool = false, ignoreIngredients: Bool = false) async -> [RecipeModel] {
        guard var components = URLComponents(url: baseURL.appendingPathComponent("recipes/complexSearch"),
                                             resolvingAgainstBaseURL: false
        ) else {
            print("Invalid URL")
            return []
        }
        
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "number", value: String(number)),
            URLQueryItem(name: "addRecipeInformation", value: "true"),
            URLQueryItem(name: "addRecipeInstructions", value: "true"),
            URLQueryItem(name: "fillIngredients", value: "true"),
        ]
        
        // Broad Search (loosely checks titles, descriptions, etc.)
        if broad  {
            // Match any recipe fields while ignoring ingredients, only using search query
            if ignoreIngredients {
                queryItems.append(URLQueryItem(name: "query", value: query))
            }
            
            // Match any recipe fields with ingredients and search query
            else {
                let joined = (ingredients + [query]).joined(separator: " ")
                queryItems.append(URLQueryItem(name: "query", value: joined))
            }
        }
        
        // Strict Search (all ingredients MUST be present)
        else {
            // Add ingredients if they exist in pantry, strict comparison
            if !ingredients.isEmpty {
                let joined = ingredients.joined(separator: ",")
                queryItems.append(URLQueryItem(name: "includeIngredients", value: joined))
                queryItems.append(URLQueryItem(name: "titleMatch", value: query))
            }
        }
        
        // Sort recipes by maximum used ingredients unless searching for specific item
        if query.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            queryItems.append(URLQueryItem(name: "sort", value: "max-used-ingredients"))
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            print("Invalid URL")
            return []
        }
        
        let request = makeRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(ComplexSearchResponse.self, from: data)
            return decoded.results
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return[]
        }
    }
        
    func searchRecipes(from pantry: [IngredientModel], number: Int = 10, offset: Int = 0, query: String = "", broad: Bool = false, ignoreIngredients: Bool = false) async -> [RecipeModel] {
        let ingredientNames = pantry.map { $0.name }
        return await searchRecipes(
            ingredients: ingredientNames,
            number: number,
            offset: offset,
            query: query,
            broad: broad,
            ignoreIngredients: ignoreIngredients
        )
    }
    
    // ingredients screen
    
    func fetchIngredients(of ingredientName: String) async -> [IngredientModel] {
        var ingredients: [IngredientModel] = []
        
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent("food/ingredients/search"),
            resolvingAgainstBaseURL: false
        ) else {
            print("Invalid URL")
            return []
        }
        
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "query", value: ingredientName),
            URLQueryItem(name: "number", value: "5"),
            URLQueryItem(name: "metaInformation", value: "true")
        ]
        
        guard let url = components.url else {
            print("Invalid URL")
            return []
        }
        
        let request = makeRequest(url: url)
        
        do {
            // Fetch data from spoonacular API
            let (data, _) = try await URLSession.shared.data(for: request)

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

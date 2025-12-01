//
//  RecipeSummary.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/12/25.
//

// This file defines the data we use to represent a single recipe returned by the spoonacular API

import Foundation
import SwiftData

// Decodable protocol converts JSON to Swift objects
// Identifiable protocol uses the id property below to give each recipe a unique identity
// Hashable protocol allows recipes to be stored in sets so they can easily be compared or updated

// The model supports:
// - A custom initializer that accepts arrays and encodes them into JSON.
// - A Decodable initializer that directly maps API JSON into the model.

// Manages single step in recipe instruction
struct InstructionStep: Codable, Hashable {
    var number: Int
    var step: String
}

// Manages single group of many recipe instructions
struct InstructionGroup: Codable, Hashable {
    var name: String?
    var steps: [InstructionStep]
}

// SwiftData model storing various recipe information
@Model
class RecipeModel: Decodable, Identifiable, Hashable {
    @Attribute(.unique) var id: Int
    var title: String
    var image: String?

    var readyInMinutes: Int?
    var servings: Int?

    var usedIngredientCount: Int?
    var missedIngredientCount: Int?

    var summary: String?
    var healthScore: Double?
    
    // Raw JSON stored to avoid relationship errors
    var analyzedInstructionsJSON: Data?
    var extendedIngredientsJSON: Data?

    // Transient, not stored in SwiftData, computed property decoded from stored json
    @Transient
    var analyzedInstructions: [InstructionGroup] {
        if let data = analyzedInstructionsJSON {
            return (try? JSONDecoder().decode([InstructionGroup].self, from: data)) ?? []
        }
        return []
    }

    @Transient
    var extendedIngredients: [IngredientModel] {
        if let data = extendedIngredientsJSON {
            return (try? JSONDecoder().decode([IngredientModel].self, from: data)) ?? []
        }
        return []
    }

    // Ratio of used to missed ingredients
    var matchRatio: Double {
        let used = usedIngredientCount ?? 0
        let missed = missedIngredientCount ?? 0
        let total = used + missed
        return total == 0 ? 0 : Double(used) / Double(total)
    }

    var matchPercent: Int {
        Int(matchRatio * 100)
    }

    init(
        id: Int = -1,
        title: String = "",
        image: String? = "",
        readyInMinutes: Int? = 0,
        servings: Int? = 0,
        usedIngredientCount: Int? = 0,
        missedIngredientCount: Int? = 0,
        summary: String? = "",
        healthScore: Double? = 0.0,
        analyzedInstructions: [InstructionGroup] = [],
        extendedIngredients: [IngredientModel] = []
    ) {
        self.id = id
        self.title = title
        self.image = image
        self.readyInMinutes = readyInMinutes
        self.servings = servings
        self.usedIngredientCount = usedIngredientCount
        self.missedIngredientCount = missedIngredientCount
        self.summary = summary
        self.healthScore = healthScore

        // Encode arrays as JSON for storage
        self.analyzedInstructionsJSON = try? JSONEncoder().encode(analyzedInstructions)
        self.extendedIngredientsJSON = try? JSONEncoder().encode(extendedIngredients)
    }

    // Decodable initializer
    // Needed to convert JSON from Spoonacular API into our Swift model
    required convenience init(from decoder: Decoder) throws {
        
        // Keyed container, allows for reading each key by name
        let c = try decoder.container(keyedBy: CodingKeys.self)

        let id = try c.decode(Int.self, forKey: .id)
        let title = try c.decode(String.self, forKey: .title)
        let image = try c.decodeIfPresent(String.self, forKey: .image)

        let readyInMinutes = try c.decodeIfPresent(Int.self, forKey: .readyInMinutes)
        let servings = try c.decodeIfPresent(Int.self, forKey: .servings)
        let usedIngredientCount = try c.decodeIfPresent(Int.self, forKey: .usedIngredientCount)
        let missedIngredientCount = try c.decodeIfPresent(Int.self, forKey: .missedIngredientCount)
        let summary = try c.decodeIfPresent(String.self, forKey: .summary)
        let healthScore = try c.decodeIfPresent(Double.self, forKey: .healthScore)

        let analyzedInstructions =
            try c.decodeIfPresent([InstructionGroup].self, forKey: .analyzedInstructions) ?? []
        let extendedIngredients =
            try c.decodeIfPresent([IngredientModel].self, forKey: .extendedIngredients) ?? []

        self.init(
            id: id,
            title: title,
            image: image,
            readyInMinutes: readyInMinutes,
            servings: servings,
            usedIngredientCount: usedIngredientCount,
            missedIngredientCount: missedIngredientCount,
            summary: summary,
            healthScore: healthScore,
            analyzedInstructions: analyzedInstructions,
            extendedIngredients: extendedIngredients
        )
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case readyInMinutes
        case servings
        case usedIngredientCount
        case missedIngredientCount
        case summary
        case healthScore
        case analyzedInstructions
        case extendedIngredients
    }
}

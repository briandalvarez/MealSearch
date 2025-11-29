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

@Model
class InstructionStep: Decodable, Hashable {
    var number: Int
    var step: String

    init(number: Int, step: String) {
        self.number = number
        self.step = step
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let number = try container.decode(Int.self, forKey: .number)
        let step = try container.decode(String.self, forKey: .step)
        self.init(number: number, step: step)
    }

    enum CodingKeys: String, CodingKey {
        case number, step
    }
}


@Model
class InstructionGroup: Decodable, Hashable {
    var name: String?
    
    @Relationship(deleteRule: .cascade, inverse: nil)
    var steps: [InstructionStep]

    init(name: String? = nil, steps: [InstructionStep]) {
        self.name = name
        self.steps = steps
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let steps = try container.decode([InstructionStep].self, forKey: .steps)
        self.init(name: name, steps: steps)
    }

    enum CodingKeys: String, CodingKey {
        case name, steps
    }
}

@Model
class RecipeModel: Decodable, Identifiable, Hashable {

    // Stored properties
    @Attribute(.unique) var id: Int
    var title: String
    var image: String?

    var readyInMinutes: Int?
    var servings: Int?

    var usedIngredientCount: Int?
    var missedIngredientCount: Int?

    var summary: String?
    var healthScore: Double?
    
    @Relationship(deleteRule: .cascade, inverse: nil)
    var analyzedInstructions: [InstructionGroup] = []
    
    @Relationship(deleteRule: .cascade, inverse: nil)
    var extendedIngredients: [IngredientModel] = []

    
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
        id: Int,
        title: String,
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
        self.analyzedInstructions = analyzedInstructions
        self.extendedIngredients = extendedIngredients
    }

    required convenience init(from decoder: Decoder) throws {

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

        let analyzedInstructions = try c.decodeIfPresent([InstructionGroup].self, forKey: .analyzedInstructions) ?? []
        let extendedIngredients = try c.decodeIfPresent([IngredientModel].self, forKey: .extendedIngredients) ?? []

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


//struct InstructionGroup: Decodable, Hashable {
//    let name: String?
//    let steps: [InstructionStep]
//}
//
//struct InstructionStep: Decodable, Hashable {
//    let number: Int
//    let step: String
//}
//
//struct RecipeModel: Decodable, Identifiable, Hashable {
//    // Required details for each recipe
//    // Based on the spoonacular API's JSON key-value pair names in documentation
//    let id: Int
//    let title: String
//    let image: String?
//    
//    let readyInMinutes: Int?
//    let servings: Int? 
//    
//    let usedIngredientCount: Int?
//    let missedIngredientCount: Int?
//    
//    let summary: String?
//    let healthScore: Double?
//    let analyzedInstructions: [InstructionGroup]
//    let extendedIngredients: [IngredientModel]
//    
//    // Calculate the percentage of ingredients the user already has for the ingredient wheel
//    var matchRatio: Double {
//        let used = usedIngredientCount ?? 0
//        let missed = missedIngredientCount ?? 0
//        let total = used + missed
//        guard total > 0 else { return 0 }
//        return Double(used) / Double(total)
//    }
//    
//    var matchPercent:Int {
//        Int((matchRatio * 100).rounded())
//    }
//}

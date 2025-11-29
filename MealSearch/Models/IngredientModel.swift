//
//  IngredientSummary.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/17/25.
//

import Foundation
import SwiftData

@Model
class IngredientModel: Identifiable, Hashable, Decodable {
    var id: Int
    var name: String
    var original: String
    var image: String?
    var amount: Double?
    var unit: String?
    var aisle: String?
    
    @Relationship(inverse: nil)
    var recipe: RecipeModel? = nil
    
    init(id: Int, name: String, original: String = "", image: String? = "", amount: Double? = 0.0, unit: String? = "", aisle: String? = "") {
        self.id = id
        self.name = name
        self.original = original
        self.image = image
        self.amount = amount
        self.unit = unit
        self.aisle = aisle
    }
    
    var formattedImage: String {
        if let img = image {
            if img.contains("spoonacular") {
                return img
            } else {
                return "https://img.spoonacular.com/ingredients_100x100/" + img

            }
        }
        return "https://via.placeholder.com/100"
    }
    
    required convenience init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let id = try container.decode(Int.self, forKey: .id)
            let name = try container.decode(String.self, forKey: .name)
            let original = try container.decodeIfPresent(String.self, forKey: .original) ?? ""
            let image = try container.decodeIfPresent(String.self, forKey: .image)
            let amount = try container.decodeIfPresent(Double.self, forKey: .amount)
            let unit = try container.decodeIfPresent(String.self, forKey: .unit)
            let aisle = try container.decodeIfPresent(String.self, forKey: .aisle)

            self.init(
                id: id,
                name: name,
                original: original,
                image: image,
                amount: amount,
                unit: unit,
                aisle: aisle
            )
        }

        private enum CodingKeys: String, CodingKey {
            case id, name, original, image, amount, unit, aisle
        }
}

//struct IngredientModel: Decodable, Identifiable, Hashable {
//    let id: Int
//    var name: String
//    var original: String = ""
//    let image: String?
//
//    var formattedImage: String {
//        if let img = image {
//            if img.contains("spoonacular") {
//                return img
//            } else {
//                return "https://img.spoonacular.com/ingredients_100x100/" + img
//
//            }
//        }
//        return "https://via.placeholder.com/100"
//    }
//
//    var amount: Double? = 0.0
//    var unit: String? = ""
//    let aisle: String?
//}

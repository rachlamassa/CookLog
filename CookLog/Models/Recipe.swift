//
//  RecipeData.swift
//  CookLog
//

import Foundation
import SwiftData

struct Ingredient: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var amount: String
}

@Model
class Recipe: Identifiable {
    var name: String
    var cookTime: String

    @Attribute(.externalStorage)
    var mealTypes: [String]

    @Attribute(.externalStorage)
    var ingredients: [Ingredient]

    var instructions: String
    var imageData: Data?

    init(name: String, cookTime: String, mealTypes: [String], ingredients: [Ingredient], instructions: String, imageData: Data? = nil) {
        self.name = name
        self.cookTime = cookTime
        self.mealTypes = mealTypes
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
    }
}

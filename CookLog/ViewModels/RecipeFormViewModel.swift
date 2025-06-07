//
//  RecipeFormViewModel.swift
//  CookLog
//

import Foundation
import SwiftData
import SwiftUI
import PhotosUI

@Observable
class RecipeFormViewModel {
    // form state
    var recipeName = ""
    var selectedMealTypes: [String] = []
    var selectedPhoto: PhotosPickerItem? = nil
    var selectedUIImage: UIImage? = nil
    var cookHours = "0"
    var cookMinutes = "0"
    var cookSeconds = "0"
    var recipeIngredientName = ""
    var recipeIngredientAmount = "1"
    var recipeIngredientUnit = "tsp"
    var recipeInstructions = ""

    // data
    var ingredients: [Ingredient] = []
    var editingRecipe: Recipe
    var isNew: Bool

    // validation
    var showIngredientError = false
    var showCookTimeError = false
    var showNameError = false
    var showIngredientNoneError = false

    // user-dependant choices
    let timeValues = (0...59).map { "\($0)" }
    let amounts = ["¼", "½", "¾", "1", "1½", "2", "2½", "3", "4", "5", "6", "7", "8", "9", "10"]
    let measurementUnits = ["tsp", "tbsp", "cup", "ml", "l", "oz", "fl oz", "g", "kg", "lb", "pinch", "dash", "pcs", "slice", "clove", "can", "package", "stick"]

    // sets up view model with a recipe, if it is not new the recipe data will be loaded.
    init(editingRecipe: Recipe, isNew: Bool) {
        self.editingRecipe = editingRecipe
        self.isNew = isNew

        if !isNew {
            loadRecipeData()
        }
    }

    func addIngredient() {
        // show error if ingredient name is missing
        guard !recipeIngredientName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showIngredientError = true
            return
        }

        let ingredient = Ingredient(name: recipeIngredientName, amount: "\(recipeIngredientAmount) \(recipeIngredientUnit)")
        ingredients.append(ingredient)

        // reset to default value
        recipeIngredientName = ""
        recipeIngredientAmount = "1"
        recipeIngredientUnit = "tsp"
        showIngredientError = false
    }

    func deleteIngredient(_ ingredient: Ingredient) {
        ingredients.removeAll { $0.id == ingredient.id }    // removes by matching id
    }

    func saveRecipe(context: ModelContext) -> Bool {
        let trimmedName = recipeName.trimmingCharacters(in: .whitespaces)
        let cookParts = [
            cookHours != "0" ? "\(cookHours) hr" : nil,
            cookMinutes != "0" ? "\(cookMinutes) min" : nil,
            cookSeconds != "0" ? "\(cookSeconds) sec" : nil
        ].compactMap { $0 }

        guard !trimmedName.isEmpty else {
            showNameError = true
            return false
        }
        guard !cookParts.isEmpty else {
            showCookTimeError = true
            return false
        }
        guard !ingredients.isEmpty else {
            showIngredientNoneError = true
            return false
        }

        let imageData = selectedUIImage?.jpegData(compressionQuality: 0.8)

        editingRecipe.name = trimmedName
        editingRecipe.cookTime = cookParts.joined(separator: " ")
        editingRecipe.mealTypes = selectedMealTypes
        editingRecipe.ingredients = ingredients
        editingRecipe.instructions = recipeInstructions
        editingRecipe.imageData = imageData

        if isNew {
            context.insert(editingRecipe)
        }

        do {
            try context.save()
            return true
        } catch {
            print("❌ Failed to save recipe:", error)
            return false
        }
    }

    private func loadRecipeData() {
        // gather the selected recipe's data to be changed by the user
        recipeName = editingRecipe.name
        selectedMealTypes = editingRecipe.mealTypes
        recipeInstructions = editingRecipe.instructions
        ingredients = editingRecipe.ingredients
        selectedUIImage = editingRecipe.imageData.flatMap { UIImage(data: $0) }

        // unparse the cook time
        let parts = editingRecipe.cookTime.components(separatedBy: " ")
        for index in stride(from: 0, to: parts.count, by: 2) where index + 1 < parts.count {
            let value = parts[index], unit = parts[index + 1]
            switch unit {
            case "hr": cookHours = value
            case "min": cookMinutes = value
            case "sec": cookSeconds = value
            default: break
            }
        }
    }
}

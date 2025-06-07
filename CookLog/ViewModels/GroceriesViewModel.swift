//
//  GroceriesViewModel.swift
//  CookLog
//

import Foundation
import SwiftData

@Observable
class GroceriesViewModel {
    // go through each meal in the week and extract the ingredients
    func ingredientsForCurrentWeek(from dailyMeals: [WeeklyMeals]) -> [Ingredient] {
        var allIngredients: [Ingredient] = []
        for day in dailyMeals {
            for meal in day.meals {
                allIngredients.append(contentsOf: meal.recipe.ingredients)
            }
        }
        return allIngredients
    }

    // parse the ingredients and create/ insert groceries
    func updateGroceries(from meals: [WeeklyMeals], groceries: [Groceries], context: ModelContext) {
        let ingredients = ingredientsForCurrentWeek(from: meals)
        let parsed = parseIngredients(ingredients: ingredients)

        for (name, measurements) in parsed {
            let combined = formatMeasurements(measurements)
            if let existing = groceries.first(where: { $0.name == name }) {
                existing.amount = combined
            } else {
                let newGrocery = Groceries(name: name, amount: combined)
                context.insert(newGrocery)
            }
        }

        let parsedNames = Set(parsed.keys)
        for grocery in groceries {
            if !parsedNames.contains(grocery.name) {
                context.delete(grocery)
            }
        }

        do {
            try context.save()
        } catch {
            print("Error saving groceries: \(error)")
        }
    }

    // "list" of groceries
    func formatMeasurements(_ measurements: [Measurement<Dimension>]) -> String {
        measurements.map { formatSingleMeasurement($0) }.joined(separator: ", ")
    }

    func formatSingleMeasurement(_ m: Measurement<Dimension>) -> String {
        let value = m.value == floor(m.value) ? String(Int(m.value)) : String(format: "%.2f", m.value)
        return "\(value) \(m.unit.symbol)"
    }
}

//
//  Grocery.swift
//  CookLog
//

import Foundation
import SwiftData

// go through the meals scheduled for the current week and returns the ingredients of each
func extractIngredients(dailyMeals: WeeklyMeals) -> [Ingredient]{
    var groceryList: [Ingredient] = []
    for meal in dailyMeals.meals{
        groceryList.append(contentsOf: meal.recipe.ingredients)
    }
    return groceryList
}

// converts string input values to doubles and measurement units, uses map to conversion
func parseIngredients(ingredients: [Ingredient]) -> [String: [Measurement<Dimension>]] {
    var ingredientsMap: [String: [Measurement<Dimension>]] = [:]
    
    let amountValues: [String: Double] = [
        "¼": 0.25, "½": 0.5, "¾": 0.75, "1": 1.0, "1½": 1.5,
        "2": 2.0, "2½": 2.5, "3": 3.0, "4": 4.0, "5": 5.0,
        "6": 6.0, "7": 7.0, "8": 8.0, "9": 9.0, "10": 10.0
    ]
    
    let unitMap: [String: Dimension] = [
        // volume units
        "tsp": UnitVolume.teaspoons,
        "tbsp": UnitVolume.tablespoons,
        "cup": UnitVolume.cups,
        "ml": UnitVolume.milliliters,
        "l": UnitVolume.liters,
        "oz": UnitVolume.fluidOunces,
        "fl oz": UnitVolume.fluidOunces,
        
        // mass units
        "g": UnitMass.grams,
        "kg": UnitMass.kilograms,
        "lb": UnitMass.pounds,
        
        // custom units
        "pinch": UnitCustom.pinch,
        "dash": UnitCustom.dash,
        "pcs": UnitCustom.pcs,
        "slice": UnitCustom.slice,
        "clove": UnitCustom.clove,
        "can": UnitCustom.can,
        "package": UnitCustom.package,
        "stick": UnitCustom.stick
    ]
    
    for ingredient in ingredients {
        // parse ingredient amount, starts as "1 tsp"
        let parts = ingredient.amount.split(separator: " ")
        guard
            parts.count >= 2,
            let qtyToken = parts.first, // first part is numerical amount
            let unitToken = parts.last, // last part is the unit
            let qty = amountValues[String(qtyToken)],
            let unit = unitMap[String(unitToken)]
        else { continue }
        
        let newMeas = Measurement(value: qty, unit: unit)
        
        // append map or create new entry
        if var existingArray = ingredientsMap[ingredient.name] {
            existingArray.append(newMeas)
            ingredientsMap[ingredient.name] = existingArray
        } else {
            ingredientsMap[ingredient.name] = [newMeas]
        }
    }
    
    return ingredientsMap
}

func formatMeasurement(_ measurement: Measurement<Dimension>) -> String {
    let formatter = MeasurementFormatter()
    formatter.unitOptions = .providedUnit
    formatter.unitStyle = .long
    return formatter.string(from: measurement)
}

@Model
class Groceries: Identifiable {
    var name: String
    var amount: String
    var isChecked: Bool = false
    init (name: String, amount: String) {
        self.name = name
        self.amount = amount
    }
}

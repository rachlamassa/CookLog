//
//  Week.swift
//  CookLog
//

import Foundation
import SwiftData

@Model
class WeeklyMeals {
    var date: Date
    var meals: [DailyMeals] = []

    init(date: Date) {
        self.date = date
    }
}

@Model
class DailyMeals {
    var recipe: Recipe
    var id = UUID()

    init(recipe: Recipe) {
        self.recipe = recipe
    }
}

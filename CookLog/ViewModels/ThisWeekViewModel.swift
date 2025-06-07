//
//  ThisWeekViewModel.swift
//  CookLog
//

import Foundation
import SwiftData

@Observable // makes view model reactive - updates UI
class ThisWeekViewModel {

    var weekDates: [Date] = []
    var selectedDate: Date?
    var selectedRecipe: Recipe?

    // week dates are generated whenever view model is called
    init() {
        generateWeekDates()
    }

    // generates the days of the current week
    func generateWeekDates(for date: Date = Date()) {
        guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: date) else {
            weekDates = []
            return
        }

        weekDates = (0..<7).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: weekInterval.start)
        }
    }

    // searches for meals matching a specific date
    func dailyMeals(for date: Date, from allMeals: [WeeklyMeals]) -> WeeklyMeals? {
        allMeals.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func addRecipe(_ recipe: Recipe, to date: Date, in allMeals: inout [WeeklyMeals], using context: ModelContext) {
        let entry = DailyMeals(recipe: recipe)

        if let existing = dailyMeals(for: date, from: allMeals) {
            existing.meals.append(entry)
        } else {
            let newDaily = WeeklyMeals(date: date)
            newDaily.meals = [entry]
            context.insert(newDaily)
            allMeals.append(newDaily)
        }

        do {
            try context.save()
        } catch {
            print("Error saving meal entry: \(error)")
        }
    }
}

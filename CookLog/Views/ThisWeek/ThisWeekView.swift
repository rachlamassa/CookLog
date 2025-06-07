//
//  ThisWeekView.swift
//  CookLog
//

import SwiftUI
import SwiftData

struct ThisWeekView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var dailyMeals: [WeeklyMeals]
    @Query private var groceries: [Groceries]

    @State private var viewModel = ThisWeekViewModel()
    @State private var selectedDailyMeal: WeeklyMeals?
    @State private var selectedRecipe: Recipe?

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Image(systemName: "fork.knife")
                Text("This Week")
            }
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(Color("normal_text"))

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.weekDates, id: \.self) { date in
                        let meal = viewModel.dailyMeals(for: date, from: dailyMeals)

                        DailyMealSection(
                            date: date,
                            dailyMeal: meal,
                            onAddRecipe: { selectedDailyMeal = $0 },
                            selectedRecipe: $selectedRecipe
                        )
                    }
                }
                .padding(.bottom)
            }
        }
        .padding()
        .onAppear {
            handleWeeklyReset()
            viewModel.generateWeekDates()
        }
        .sheet(item: $selectedDailyMeal) { meal in
            SelectRecipeView(
                dailyMeal: meal,
                showSelectRecipe: Binding(
                    get: { selectedDailyMeal != nil },
                    set: { if !$0 { selectedDailyMeal = nil } }
                )
            )
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeView(recipe: recipe, selectedRecipe: $selectedRecipe)
        }
    }

    private func currentWeekIdentifier(for date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-'W'ww"
        return formatter.string(from: date)
    }

    private func handleWeeklyReset() {
        let currentWeek = currentWeekIdentifier()
        let storedWeek = UserDefaults.standard.string(forKey: "lastWeekIdentifier")

        if currentWeek != storedWeek {
            dailyMeals.forEach { modelContext.delete($0) }
            groceries.forEach { modelContext.delete($0) }
            try? modelContext.save()
            UserDefaults.standard.set(currentWeek, forKey: "lastWeekIdentifier")
        }
    }
}

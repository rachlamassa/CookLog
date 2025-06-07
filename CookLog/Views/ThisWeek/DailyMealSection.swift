import SwiftUI
import SwiftData

struct DailyMealSection: View {
    @Environment(\.modelContext) private var modelContext
    @Query var groceries: [Groceries]
    @Query private var dailyMeals: [WeeklyMeals]

    let date: Date
    let dailyMeal: WeeklyMeals?
    let onAddRecipe: (WeeklyMeals) -> Void
    @Binding var selectedRecipe: Recipe?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header

            if let dailyMeal = dailyMeal {
                if dailyMeal.meals.isEmpty {
                    Text("No meals yet.")
                        .foregroundStyle(Color("accent_text"))
                } else {
                    ForEach(dailyMeal.meals, id: \.self) { entry in
                        HStack {
                            RecipeCardLong(recipe: entry.recipe)
                                .onTapGesture {
                                    selectedRecipe = entry.recipe
                                }
                            Button {
                                deleteMeal(entry)
                            } label: {
                                Image(systemName: "multiply")
                                    .foregroundColor(Color("normal_text"))
                            }
                        }
                    }
                }
            } else {
                Text("No meals yet.")
                    .foregroundStyle(Color("accent_text"))
            }

            Divider()
        }
        .padding(.bottom)
    }

    // Header with formatted date and plus button
    private var header: some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, y"

        return HStack(spacing: 10) {
            Text(formatter.string(from: date))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color("normal_text"))

            Button {
                let newMeal = dailyMeal ?? WeeklyMeals(date: date)
                if dailyMeal == nil {
                    modelContext.insert(newMeal)
                    try? modelContext.save()
                }
                onAddRecipe(newMeal)
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(Color("button"))
                    .fontWeight(.semibold)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .background(Color("background_beige"))
    }

    private func deleteMeal(_ entry: DailyMeals) {
        guard let dailyMeal = dailyMeal else { return }

        if let index = dailyMeal.meals.firstIndex(of: entry) {
            dailyMeal.meals.remove(at: index)
        }

        let removedIngredients = entry.recipe.ingredients
        modelContext.delete(entry)

        for ingredient in removedIngredients {
            if !isIngredientStillUsed(ingredient) {
                if let grocery = groceries.first(where: { $0.name == ingredient.name }) {
                    modelContext.delete(grocery)
                }
            }
        }

        try? modelContext.save()
    }

    private func isIngredientStillUsed(_ ingredient: Ingredient) -> Bool {
        for meal in dailyMeals {
            for entry in meal.meals {
                if entry.recipe.ingredients.contains(where: { $0.name == ingredient.name }) {
                    return true
                }
            }
        }
        return false
    }
}

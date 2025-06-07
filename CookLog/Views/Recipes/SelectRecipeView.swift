//
//  SelectRecipeView.swift
//  CookLog
//
//  same as home view, but clicking a recipe adds it to the respective day. you cannot add a recipe through this screen

import SwiftUI
import SwiftData

struct SelectRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var recipes: [Recipe]

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    @Bindable var dailyMeal: WeeklyMeals
    @Binding var showSelectRecipe: Bool

    @State private var recipeSearch = ""
    @State private var selectedMealTypes: [String] = ["All"]
    @State private var selectedRecipe: Recipe? = nil

    private var filteredRecipes: [Recipe] {
        recipes.filter {
            (selectedMealTypes.isEmpty || selectedMealTypes.contains("All") || $0.mealTypes.contains(where: selectedMealTypes.contains)) &&
            (recipeSearch.isEmpty || $0.name.lowercased().contains(recipeSearch.lowercased()))
        }
    }

    private let mealFilters = ["All", "Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        VStack(spacing: 20) {
            searchBar
            filterBar
            recipeGrid
        }
        .padding()
        .background(Color("background_beige"))
        .navigationTitle("Select a Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedRecipe) { recipe in
            RecipeView(recipe: recipe, selectedRecipe: $selectedRecipe)
        }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading, 8)
                .foregroundColor(Color("normal_text"))

            TextField("Search recipes...", text: $recipeSearch)
                .padding(10)
                .foregroundColor(Color("accent_text"))
        }
        .background(Color.white)
        .cornerRadius(10)
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(["All", "Breakfast", "Lunch", "Dinner", "Snack"], id: \.self) { type in
                    CustomButton(selectedButtons: $selectedMealTypes, buttonType: type)
                }
            }
        }
    }

    private var recipeGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(filteredRecipes) { recipe in
                    Button {
                        let entry = DailyMeals(recipe: recipe)
                        dailyMeal.meals.append(entry)
                        try? modelContext.save()
                        showSelectRecipe = false
                    } label: {
                        RecipeCard(recipe: recipe)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

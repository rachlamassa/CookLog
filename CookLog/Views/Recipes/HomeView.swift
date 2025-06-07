//
//  HomeView.swift
//  CookLog
//
//  Created by Rachael LaMassa on 4/27/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var recipes: [Recipe]
    
    // defines two column in the lazy v grid
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    // default filters
    @State private var recipeSearch = ""
    @State private var selectedButtons: [String] = ["All"]
    
    // sheets
    @State private var showAddRecipe = false
    @State private var showRecipe = false
    @State private var selectedRecipe: Recipe? = nil

    // filters recipes based on user input
    private var filteredRecipes: [Recipe] {
        let filteredByMeal: [Recipe]
        
        if selectedButtons.isEmpty || selectedButtons.contains("All") {
            filteredByMeal = recipes
        } else {
            filteredByMeal = recipes.filter { recipe in
                recipe.mealTypes.contains(where: selectedButtons.contains)
            }
        }
        
        // filter the filtered recipes list if the user inputs text into the search bar
        if recipeSearch.isEmpty {
            return filteredByMeal
        } else {
            return filteredByMeal.filter { $0.name.localizedCaseInsensitiveContains(recipeSearch) }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    headerSection

                    ScrollView {
                        searchBar
                            .padding(.vertical)
                        filterBar
                            .padding(.bottom)
                        
                        if filteredRecipes.isEmpty {    // show a message if there are no recorded recipes
                            Text("Start by adding a recipe!")
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundStyle(Color("accent_text"))
                        } else {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(filteredRecipes) { recipe in
                                    Button {
                                        selectedRecipe = recipe
                                    } label: {
                                        RecipeCard(recipe: recipe)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 10)
                        }

                        AddRecipeButton() { // only shows the recipe sheet (accessing the form)
                            showAddRecipe = true
                        }
                        .padding()
                    }
                    .sheet(item: $selectedRecipe) { recipe in
                        RecipeView(recipe: recipe, selectedRecipe: $selectedRecipe)
                    }
                    .sheet(isPresented: $showAddRecipe) {
                        RecipeFormView(showAddRecipe: $showAddRecipe)
                    }
                }
            }
            .padding()
        }
    }

    private var headerSection: some View {
        HStack {
            Image(systemName: "house.lodge.fill")
            Text("Your Recipes")
            Spacer()
        }
        .font(.title2)
        .fontWeight(.bold)
        .foregroundStyle(Color("normal_text"))
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading, 8)
                .foregroundColor(Color("normal_text"))
            TextField(
                "Search recipes...",
                text: $recipeSearch,
                prompt: Text("Search recipes...").foregroundColor(Color("accent_text"))
            )
            .padding(.vertical, 10)
            .background(Color.white)
        }
        .background(Color.white)
        .cornerRadius(10)
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(["All", "Breakfast", "Lunch", "Dinner", "Snack"], id: \.self) { type in
                    CustomButton(selectedButtons: $selectedButtons, buttonType: type)
                }
            }
        }
    }
}

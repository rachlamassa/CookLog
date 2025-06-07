//
//  RecipeView.swift
//  CookLog
//

import SwiftUI
import SwiftData

struct RecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var recipe: Recipe    // in case the user decides to edit the recipe
    @State private var showEditRecipe = false
    @Binding var selectedRecipe: Recipe?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                recipeImage
                recipeHeader
                ingredientSection
                instructionSection
                actionButtons
            }
            .padding()
        }
        .background(Color("background_beige"))
        .ignoresSafeArea(edges: .bottom)
    }

    private var recipeImage: some View {
        Group {
            if let data = recipe.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.top)
                    .padding(.horizontal, 10)
            } else {
                Image("default")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.top)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var recipeHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("normal_text"))

            HStack(spacing: 6) {
                Text(recipe.cookTime)
                if !recipe.mealTypes.isEmpty {
                    Image(systemName: "circle.fill").font(.system(size: 4))
                    Text(recipe.mealTypes.joined(separator: ", "))
                }
            }
            .foregroundColor(Color("accent_text"))
            .font(.subheadline)
        }
    }

    private var ingredientSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ingredients")
                .fontWeight(.semibold)
                .foregroundColor(Color("button"))

            // list the ingredients and amount of each, no option to delete unless its in the form
            ForEach(recipe.ingredients) { ingredient in
                HStack {
                    Text(ingredient.name)
                        .foregroundColor(Color("normal_text"))
                    Spacer()
                    Text(ingredient.amount)
                        .foregroundColor(Color("accent_text"))
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(10)
            }
        }
    }

    // non-editable display of the instructions
    private var instructionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Instructions")
                .fontWeight(.semibold)
                .foregroundColor(Color("button"))

            Text(recipe.instructions)
                .foregroundColor(Color("normal_text"))
                .padding()
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                .background(Color.white.cornerRadius(10))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // either edit the recipe or delete it
    private var actionButtons: some View {
        HStack(spacing: 20) {
            Button {
                showEditRecipe = true
            } label: {
                Label("Edit Recipe", systemImage: "pencil")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color("button"))
                    .foregroundStyle(Color("unpressed_button"))
                    .clipShape(Capsule())
            }
            .sheet(isPresented: $showEditRecipe) {
                RecipeFormView(editingRecipe: recipe, showAddRecipe: $showEditRecipe)
            }

            Button {
                deleteRecipe()
            } label: {
                Label("Delete Recipe", systemImage: "trash.fill")
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color("button"))
                    .foregroundStyle(Color("unpressed_button"))
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func deleteRecipe() {
        do {
            // 1. Remove recipe from daily meals
            let meals = try modelContext.fetch(FetchDescriptor<WeeklyMeals>())
            meals.forEach { $0.meals.removeAll { $0.recipe == recipe } }

            // 2. Collect remaining ingredients
            let usedIngredients: Set<String> = Set(
                meals.flatMap { $0.meals.flatMap { $0.recipe.ingredients.map(\.name) } }
            )

            // 3. Remove groceries no longer in use
            let groceries = try modelContext.fetch(FetchDescriptor<Groceries>())
            for grocery in groceries where !usedIngredients.contains(grocery.name) {
                modelContext.delete(grocery)
            }

            // 4. Delete the recipe
            modelContext.delete(recipe)
            try modelContext.save()
            selectedRecipe = nil
        } catch {
            print("Error deleting recipe: \(error)")
        }
    }
}

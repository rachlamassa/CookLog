//
//  RecipeFormView.swift
//  CookLog
//

import SwiftUI
import SwiftData
import PhotosUI

struct RecipeFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode

    @Binding var showAddRecipe: Bool
    @FocusState private var isNameFieldFocused: Bool
    @State private var viewModel: RecipeFormViewModel

    // initialization when adding a new recipe
    init(showAddRecipe: Binding<Bool>) {
        let newRecipe = Recipe(name: "", cookTime: "", mealTypes: ["Breakfast"], ingredients: [], instructions: "", imageData: nil)
        _viewModel = State(initialValue: RecipeFormViewModel(editingRecipe: newRecipe, isNew: true))
        _showAddRecipe = showAddRecipe
    }

    // initialization when editing an existing recipe
    init(editingRecipe: Recipe, showAddRecipe: Binding<Bool>) {
        _viewModel = State(initialValue: RecipeFormViewModel(editingRecipe: editingRecipe, isNew: false))
        _showAddRecipe = showAddRecipe
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                formTitle
                nameField
                mealPicker
                photoPicker
                cookTimeSection
                ingredientsSection
                instructionsSection
                submitButton
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
        .background(Color("background_beige"))
        .onTapGesture {
            viewModel.showIngredientError = false
            viewModel.showCookTimeError = false
            viewModel.showNameError = false
            viewModel.showIngredientNoneError = false
        }
        .onChange(of: viewModel.selectedPhoto) {
            Task {
                if let data = try? await viewModel.selectedPhoto?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.selectedUIImage = image
                }
            }
        }
    }

    private var formTitle: some View {
        Text(viewModel.isNew ? "Add Recipe" : "Edit Recipe")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(Color("normal_text"))
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Meal Name").fontWeight(.semibold).foregroundColor(Color("button"))
            TextField("e.g. Avocado Toast", text: $viewModel.recipeName)
                .foregroundColor(Color("accent_text"))
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
            if viewModel.showNameError {
                Text("Please enter a recipe name.")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
    }

    private var mealPicker: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Meal Type").fontWeight(.semibold).foregroundColor(Color("button"))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(["Breakfast", "Lunch", "Dinner", "Snack"], id: \.self) { type in
                        CustomButton(selectedButtons: $viewModel.selectedMealTypes, buttonType: type)
                    }
                }
            }
        }
    }

    private var photoPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Add a Photo").fontWeight(.semibold).foregroundColor(Color("button"))
                Text("(optional)").font(.footnote).foregroundColor(Color("accent_text"))
            }
            HStack(spacing: 15) {
                Group {
                    if let uiImage = viewModel.selectedUIImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(10)
                    } else {
                        Image("default")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(10)
                    }
                }

                PhotosPicker(selection: $viewModel.selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    Text("+ Upload Photo")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("button"))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color("unpressed_button"))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var cookTimeSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Cook Time").fontWeight(.semibold).foregroundColor(Color("button"))
            HStack(spacing: 10) {
                PickerMenu(label: viewModel.cookHours, options: viewModel.timeValues) { viewModel.cookHours = $0 }
                Text("hr")
                PickerMenu(label: viewModel.cookMinutes, options: viewModel.timeValues) { viewModel.cookMinutes = $0 }
                Text("min")
                PickerMenu(label: viewModel.cookSeconds, options: viewModel.timeValues) { viewModel.cookSeconds = $0 }
                Text("sec")
            }
            .foregroundStyle(Color("normal_text"))
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)

            if viewModel.showCookTimeError {
                Text("Please enter a cook time greater than 0.")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ingredients").fontWeight(.semibold).foregroundColor(Color("button"))
            HStack(spacing: 10) {
                TextField("Add ingredient", text: $viewModel.recipeIngredientName)
                    .foregroundColor(Color("accent_text"))
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                PickerMenu(label: viewModel.recipeIngredientAmount, options: viewModel.amounts) { viewModel.recipeIngredientAmount = $0 }
                PickerMenu(label: viewModel.recipeIngredientUnit, options: viewModel.measurementUnits) { viewModel.recipeIngredientUnit = $0 }
                Button(action: viewModel.addIngredient) {
                    Image(systemName: "plus").foregroundColor(Color("normal_text"))
                }
            }
            if viewModel.showIngredientError {
                Text("Please input a name for your ingredient")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            if viewModel.showIngredientNoneError {
                Text("Please input at least one ingredient")
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            ForEach(viewModel.ingredients) { ingredient in
                HStack {
                    HStack {
                        Text(ingredient.name).foregroundColor(Color("normal_text"))
                        Spacer()
                        Text(ingredient.amount).foregroundColor(Color("accent_text"))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(10)
                    Button {
                        viewModel.deleteIngredient(ingredient)
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(Color("normal_text"))
                    }
                }
            }
        }
    }

    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Instructions").fontWeight(.semibold).foregroundColor(Color("button"))
            TextEditor(text: $viewModel.recipeInstructions)
                .foregroundColor(Color("accent_text"))
                .frame(height: 250)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
        }
    }

    private var submitButton: some View {
        AddRecipeButton {
            if viewModel.saveRecipe(context: modelContext) {
                presentationMode.wrappedValue.dismiss()
                showAddRecipe = false
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    struct PickerMenu: View {
        var label: String
        var options: [String]
        var onSelect: (String) -> Void

        var body: some View {
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        onSelect(option)
                    }
                }
            } label: {
                HStack(spacing: 5) {
                    Text(label)
                    Image(systemName: "chevron.up.chevron.down")
                }
                .foregroundColor(Color("normal_text"))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white)
                .cornerRadius(8)
            }
        }
    }
}

import SwiftUI

struct RecipeFormView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Form state
    @State private var name: String = ""
    @State private var ingredients: [String] = [""]
    @State private var instructions: [String] = [""]
    @State private var selectedMood: Mood = .happy
    @State private var prepTime: String = ""
    @State private var cookTime: String = ""
    @State private var servings: String = ""
    @State private var imageURL: String = ""
    
    // For editing existing recipe
    let editingRecipe: Recipe?
    
    init(viewModel: RecipeViewModel, editingRecipe: Recipe? = nil) {
        self.viewModel = viewModel
        self.editingRecipe = editingRecipe
        
        // Initialize form state if editing
        if let recipe = editingRecipe {
            _name = State(initialValue: recipe.name)
            _ingredients = State(initialValue: recipe.ingredients)
            _instructions = State(initialValue: recipe.instructions)
            _selectedMood = State(initialValue: recipe.mood)
            _prepTime = State(initialValue: recipe.prepTime)
            _cookTime = State(initialValue: recipe.cookTime)
            _servings = State(initialValue: String(recipe.servings))
            _imageURL = State(initialValue: recipe.imageURL)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Recipe Name", text: $name)
                    Picker("Mood", selection: $selectedMood) {
                        ForEach(Mood.allCases, id: \.self) { mood in
                            Text("\(mood.icon) \(mood.rawValue)").tag(mood)
                        }
                    }
                    TextField("Prep Time (e.g., 15 mins)", text: $prepTime)
                    TextField("Cook Time (e.g., 20 mins)", text: $cookTime)
                    TextField("Servings", text: $servings)
                        .keyboardType(.numberPad)
                    TextField("Image URL", text: $imageURL)
                }
                
                Section(header: Text("Ingredients")) {
                    ForEach(ingredients.indices, id: \.self) { index in
                        TextField("Ingredient \(index + 1)", text: $ingredients[index])
                    }
                    Button("Add Ingredient") {
                        ingredients.append("")
                    }
                }
                
                Section(header: Text("Instructions")) {
                    ForEach(instructions.indices, id: \.self) { index in
                        TextField("Step \(index + 1)", text: $instructions[index])
                    }
                    Button("Add Step") {
                        instructions.append("")
                    }
                }
            }
            .navigationTitle(editingRecipe == nil ? "New Recipe" : "Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty &&
        !ingredients.isEmpty &&
        !instructions.isEmpty &&
        !prepTime.isEmpty &&
        !cookTime.isEmpty &&
        !servings.isEmpty &&
        !imageURL.isEmpty &&
        ingredients.allSatisfy { !$0.isEmpty } &&
        instructions.allSatisfy { !$0.isEmpty }
    }
    
    private func saveRecipe() {
        let recipe = Recipe(
            name: name,
            ingredients: ingredients.filter { !$0.isEmpty },
            instructions: instructions.filter { !$0.isEmpty },
            mood: selectedMood,
            prepTime: prepTime,
            cookTime: cookTime,
            servings: Int(servings) ?? 1,
            imageURL: imageURL
        )
        
        if let editingRecipe = editingRecipe {
            viewModel.updateRecipe(editingRecipe, with: recipe)
        } else {
            viewModel.addRecipe(recipe)
        }
        
        dismiss()
    }
} 
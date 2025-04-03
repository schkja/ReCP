import SwiftUI

struct RecipeFormView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    // Form state
    @State private var name: String = ""
    @State private var ingredients: [String] = [""]
    @State private var instructions: [String] = [""]
    @State private var selectedMood: Mood = .happy
    @State private var prepTime: String = ""
    @State private var cookTime: String = ""
    @State private var servings: String = ""
    @State private var imageURL: String = ""
    
    @State private var showingImageOptions = false
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case name, ingredient(Int), instruction(Int), prepTime, cookTime, servings, imageURL
    }
    
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
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Recipe Image Preview
                        ZStack {
                            if !imageURL.isEmpty {
                                Image(imageURL)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipped()
                                    .cornerRadius(12)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppTheme.cardBackground)
                                    .frame(height: 200)
                                    .overlay(
                                        VStack(spacing: 12) {
                                            Image(systemName: "photo")
                                                .font(.system(size: 40))
                                                .foregroundColor(AppTheme.secondaryText)
                                            
                                            Text("Tap to add an image")
                                                .font(.headline)
                                                .foregroundColor(AppTheme.secondaryText)
                                        }
                                    )
                            }
                        }
                        .onTapGesture {
                            showingImageOptions = true
                        }
                        .padding(.horizontal)
                        
                        // Recipe Name
                        FormSection(title: "Recipe Name", systemImage: "textformat") {
                            TextField("Name", text: $name)
                                .font(.title3)
                                .padding()
                                .background(AppTheme.cardBackground)
                                .cornerRadius(10)
                                .focused($focusedField, equals: .name)
                        }
                        
                        // Mood Selection
                        FormSection(title: "Mood", systemImage: "heart.fill") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(Mood.allCases, id: \.self) { mood in
                                        MoodSelectionButton(
                                            mood: mood,
                                            isSelected: selectedMood == mood,
                                            action: {
                                                selectedMood = mood
                                            }
                                        )
                                    }
                                }
                                .padding(.vertical, 5)
                                .padding(.horizontal, 5)
                            }
                            .padding(.horizontal, -5)
                        }
                        
                        // Cooking Info
                        FormSection(title: "Cooking Information", systemImage: "timer") {
                            HStack(spacing: 10) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Prep Time")
                                        .font(.caption)
                                        .foregroundColor(AppTheme.secondaryText)
                                    
                                    TextField("e.g., 15 mins", text: $prepTime)
                                        .padding(10)
                                        .background(AppTheme.cardBackground)
                                        .cornerRadius(8)
                                        .focused($focusedField, equals: .prepTime)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Cook Time")
                                        .font(.caption)
                                        .foregroundColor(AppTheme.secondaryText)
                                    
                                    TextField("e.g., 30 mins", text: $cookTime)
                                        .padding(10)
                                        .background(AppTheme.cardBackground)
                                        .cornerRadius(8)
                                        .focused($focusedField, equals: .cookTime)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Servings")
                                        .font(.caption)
                                        .foregroundColor(AppTheme.secondaryText)
                                    
                                    TextField("e.g., 4", text: $servings)
                                        .keyboardType(.numberPad)
                                        .padding(10)
                                        .background(AppTheme.cardBackground)
                                        .cornerRadius(8)
                                        .focused($focusedField, equals: .servings)
                                }
                            }
                        }
                        
                        // Ingredients
                        FormSection(
                            title: "Ingredients",
                            systemImage: "list.bullet",
                            actionButton: {
                                Button(action: {
                                    ingredients.append("")
                                    
                                    // Focus the new field after a short delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        focusedField = .ingredient(ingredients.count - 1)
                                    }
                                }) {
                                    Label("Add Ingredient", systemImage: "plus.circle.fill")
                                }
                                .foregroundColor(AppTheme.accent)
                            }
                        ) {
                            VStack(spacing: 12) {
                                ForEach(0..<ingredients.count, id: \.self) { index in
                                    HStack {
                                        TextField("Ingredient \(index + 1)", text: $ingredients[index])
                                            .padding(10)
                                            .background(AppTheme.cardBackground)
                                            .cornerRadius(8)
                                            .focused($focusedField, equals: .ingredient(index))
                                        
                                        if ingredients.count > 1 {
                                            Button(action: {
                                                ingredients.remove(at: index)
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Instructions
                        FormSection(
                            title: "Instructions",
                            systemImage: "text.badge.checkmark",
                            actionButton: {
                                Button(action: {
                                    instructions.append("")
                                    
                                    // Focus the new field after a short delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        focusedField = .instruction(instructions.count - 1)
                                    }
                                }) {
                                    Label("Add Step", systemImage: "plus.circle.fill")
                                }
                                .foregroundColor(AppTheme.accent)
                            }
                        ) {
                            VStack(spacing: 12) {
                                ForEach(0..<instructions.count, id: \.self) { index in
                                    HStack {
                                        ZStack(alignment: .topLeading) {
                                            if instructions[index].isEmpty {
                                                Text("Step \(index + 1)")
                                                    .foregroundColor(AppTheme.secondaryText)
                                                    .padding(10)
                                            }
                                            
                                            TextEditor(text: $instructions[index])
                                                .frame(minHeight: 80)
                                                .padding(5)
                                                .focused($focusedField, equals: .instruction(index))
                                        }
                                        .background(AppTheme.cardBackground)
                                        .cornerRadius(8)
                                        
                                        if instructions.count > 1 {
                                            Button(action: {
                                                instructions.remove(at: index)
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Image URL (hidden but still needed)
                        TextField("Image URL", text: $imageURL)
                            .opacity(0)
                            .frame(height: 0)
                        
                        // Save Button
                        Button(action: {
                            saveRecipe()
                        }) {
                            Text(editingRecipe == nil ? "Add Recipe" : "Save Changes")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isFormValid ? AppTheme.accent : AppTheme.secondaryText)
                                .cornerRadius(15)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                    .padding(.top)
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
            }
            .actionSheet(isPresented: $showingImageOptions) {
                ActionSheet(
                    title: Text("Select an image"),
                    message: Text("Choose a sample image for your recipe"),
                    buttons: sampleImages.map { imageName in
                        .default(Text(imageName)) {
                            imageURL = imageName
                        }
                    } + [.cancel()]
                )
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
    
    // Sample image options (can be customized based on your app's images)
    private var sampleImages: [String] {
        [
            "buddha_bowl",
            "fruit_smoothie",
            "mac_and_cheese",
            "chocolate_cookies",
            "thai_curry",
            "protein_bowl",
            "smoothie_bowl",
            "energy_bites",
            "chamomile_cookies",
            "green_bowl"
        ]
    }
}

// Form section component
struct FormSection<Content: View, Action: View>: View {
    let title: String
    let systemImage: String
    let actionButton: (() -> Action)?
    let content: () -> Content
    
    init(
        title: String,
        systemImage: String,
        @ViewBuilder actionButton: @escaping () -> Action = { EmptyView() },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.systemImage = systemImage
        self.actionButton = actionButton
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(title, systemImage: systemImage)
                    .font(.headline)
                
                Spacer()
                
                actionButton?()
            }
            
            content()
        }
        .padding(.horizontal)
    }
}

// Mood selection button for the form
struct MoodSelectionButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AppTheme.moodColor(mood) : AppTheme.moodColor(mood).opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(mood.icon)
                        .font(.system(size: 30))
                }
                
                Text(mood.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
            }
            .frame(width: 70)
            .foregroundColor(isSelected ? AppTheme.accent : AppTheme.primaryText)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
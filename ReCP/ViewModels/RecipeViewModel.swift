import Foundation

class RecipeViewModel: ObservableObject {
    @Published var currentRecipe: Recipe?
    @Published var selectedMood: Mood?
    @Published private(set) var recipes: [Recipe] = []
    private var currentRecipeIndex: Int = 0
    private var currentMoodRecipes: [Recipe] = []
    
    var nextRecipe: Recipe? {
        guard !currentMoodRecipes.isEmpty else { return nil }
        let nextIndex = (currentRecipeIndex + 1) % currentMoodRecipes.count
        return currentMoodRecipes[nextIndex]
    }
    
    var previousRecipe: Recipe? {
        guard !currentMoodRecipes.isEmpty else { return nil }
        let previousIndex = (currentRecipeIndex - 1 + currentMoodRecipes.count) % currentMoodRecipes.count
        return currentMoodRecipes[previousIndex]
    }
    
    init() {
        // Initialize with sample recipes
        recipes = Recipe.sampleRecipes
        print("Initialized with \(recipes.count) total recipes")
    }
    
    func selectMood(_ mood: Mood) {
        selectedMood = mood
        currentMoodRecipes = recipesForMood(mood)
        currentRecipeIndex = 0
        print("Selected mood: \(mood.rawValue)")
        print("Found \(currentMoodRecipes.count) recipes for mood")
        
        if !currentMoodRecipes.isEmpty {
            currentRecipe = currentMoodRecipes[0]
            print("Set first recipe: \(currentRecipe?.name ?? "nil")")
        } else {
            currentRecipe = nil
            print("No recipes found for mood")
        }
    }
    
    func getNewRecipe() {
        guard !currentMoodRecipes.isEmpty else {
            print("No recipes available for current mood")
            currentRecipe = nil
            return
        }
        
        // Get the next recipe
        let nextIndex = (currentRecipeIndex + 1) % currentMoodRecipes.count
        print("Current index: \(currentRecipeIndex), Next index: \(nextIndex)")
        print("Total recipes for mood: \(currentMoodRecipes.count)")
        
        // Update the recipe immediately
        currentRecipe = currentMoodRecipes[nextIndex]
        currentRecipeIndex = nextIndex
        print("Set new recipe: \(currentRecipe?.name ?? "nil")")
    }
    
    func goBack() {
        selectedMood = nil
        currentRecipe = nil
        currentRecipeIndex = 0
        currentMoodRecipes = []
        print("Reset to mood selection")
    }
    
    // CRUD Operations
    func recipesForMood(_ mood: Mood) -> [Recipe] {
        let recipes = recipes.filter { $0.mood == mood }
        print("Found \(recipes.count) recipes for mood: \(mood.rawValue)")
        return recipes
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        if recipe.mood == selectedMood {
            currentMoodRecipes = recipesForMood(recipe.mood)
        }
    }
    
    func updateRecipe(_ oldRecipe: Recipe, with newRecipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == oldRecipe.id }) {
            recipes[index] = newRecipe
            if currentRecipe?.id == oldRecipe.id {
                currentRecipe = newRecipe
            }
            if newRecipe.mood == selectedMood {
                currentMoodRecipes = recipesForMood(newRecipe.mood)
            }
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        if currentRecipe?.id == recipe.id {
            currentRecipe = nil
        }
        if recipe.mood == selectedMood {
            currentMoodRecipes = recipesForMood(recipe.mood)
        }
    }
    
    func deleteRecipesForMood(_ mood: Mood) {
        recipes.removeAll { $0.mood == mood }
        if currentRecipe?.mood == mood {
            currentRecipe = nil
        }
        if mood == selectedMood {
            currentMoodRecipes = []
        }
    }
} 
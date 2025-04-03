import Foundation

struct Recipe: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let mood: Mood
    let prepTime: String
    let cookTime: String
    let servings: Int
    let imageURL: String
    let isCustomImage: Bool
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    // For backward compatibility with existing code
    init(name: String, ingredients: [String], instructions: [String], mood: Mood, prepTime: String, cookTime: String, servings: Int, imageURL: String) {
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.mood = mood
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.servings = servings
        self.imageURL = imageURL
        self.isCustomImage = false
    }
    
    // New initializer with isCustomImage parameter
    init(name: String, ingredients: [String], instructions: [String], mood: Mood, prepTime: String, cookTime: String, servings: Int, imageURL: String, isCustomImage: Bool) {
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.mood = mood
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.servings = servings
        self.imageURL = imageURL
        self.isCustomImage = isCustomImage
    }
}

enum Mood: String, CaseIterable {
    case happy = "Happy"
    case sad = "Sad"
    case energetic = "Energetic"
    case tired = "Tired"
    case stressed = "Stressed"
    
    var icon: String {
        switch self {
        case .happy: return "😊"
        case .sad: return "😢"
        case .energetic: return "⚡️"
        case .tired: return "😴"
        case .stressed: return "😰"
        }
    }
}

// Sample data
extension Recipe {
    static let sampleRecipes: [Recipe] = [
        // Happy Mood Recipes
        Recipe(
            name: "Colorful Buddha Bowl",
            ingredients: ["Quinoa", "Avocado", "Cherry tomatoes", "Cucumber", "Chickpeas", "Kale", "Tahini dressing"],
            instructions: [
                "Cook quinoa according to package instructions",
                "Chop vegetables into bite-sized pieces",
                "Arrange all ingredients in a bowl",
                "Drizzle with tahini dressing"
            ],
            mood: .happy,
            prepTime: "15 mins",
            cookTime: "20 mins",
            servings: 2,
            imageURL: "buddha_bowl"
        ),
        Recipe(
            name: "Fresh Fruit Smoothie",
            ingredients: ["Mango", "Strawberries", "Banana", "Greek yogurt", "Honey", "Ice"],
            instructions: [
                "Blend all fruits with yogurt",
                "Add honey to taste",
                "Blend with ice until smooth"
            ],
            mood: .happy,
            prepTime: "5 mins",
            cookTime: "0 mins",
            servings: 2,
            imageURL: "fruit_smoothie"
        ),
        
        // Sad Mood Recipes
        Recipe(
            name: "Comforting Mac and Cheese",
            ingredients: ["Macaroni", "Cheddar cheese", "Milk", "Butter", "Flour", "Salt", "Pepper"],
            instructions: [
                "Cook macaroni according to package instructions",
                "Melt butter in a pan, add flour to make roux",
                "Gradually add milk while stirring",
                "Add cheese and stir until melted",
                "Combine with cooked pasta"
            ],
            mood: .sad,
            prepTime: "10 mins",
            cookTime: "20 mins",
            servings: 4,
            imageURL: "mac_and_cheese"
        ),
        Recipe(
            name: "Chocolate Chip Cookies",
            ingredients: ["Flour", "Butter", "Brown sugar", "Eggs", "Vanilla extract", "Chocolate chips", "Baking soda", "Salt"],
            instructions: [
                "Cream butter and sugar",
                "Add eggs and vanilla",
                "Mix in dry ingredients",
                "Fold in chocolate chips",
                "Bake at 350°F for 12 minutes"
            ],
            mood: .sad,
            prepTime: "15 mins",
            cookTime: "12 mins",
            servings: 24,
            imageURL: "chocolate_cookies"
        ),
        
        // Energetic Mood Recipes
        Recipe(
            name: "Spicy Thai Curry",
            ingredients: ["Coconut milk", "Thai curry paste", "Vegetables", "Rice", "Lime", "Cilantro"],
            instructions: [
                "Cook rice according to package instructions",
                "Sauté curry paste in oil",
                "Add coconut milk and vegetables",
                "Simmer until vegetables are tender",
                "Serve with rice and garnish with lime and cilantro"
            ],
            mood: .energetic,
            prepTime: "15 mins",
            cookTime: "25 mins",
            servings: 4,
            imageURL: "thai_curry"
        ),
        Recipe(
            name: "Protein Power Bowl",
            ingredients: ["Quinoa", "Grilled chicken", "Black beans", "Corn", "Bell peppers", "Avocado", "Lime dressing"],
            instructions: [
                "Cook quinoa",
                "Grill chicken and slice",
                "Assemble bowl with all ingredients",
                "Drizzle with lime dressing"
            ],
            mood: .energetic,
            prepTime: "20 mins",
            cookTime: "25 mins",
            servings: 2,
            imageURL: "protein_bowl"
        ),
        
        // Tired Mood Recipes
        Recipe(
            name: "Energizing Smoothie Bowl",
            ingredients: ["Banana", "Spinach", "Greek yogurt", "Honey", "Granola", "Chia seeds"],
            instructions: [
                "Blend banana, spinach, and yogurt",
                "Pour into a bowl",
                "Top with granola and chia seeds",
                "Drizzle with honey"
            ],
            mood: .tired,
            prepTime: "5 mins",
            cookTime: "0 mins",
            servings: 1,
            imageURL: "smoothie_bowl"
        ),
        Recipe(
            name: "Green Tea Energy Bites",
            ingredients: ["Dates", "Nuts", "Matcha powder", "Oats", "Honey", "Coconut"],
            instructions: [
                "Blend dates and nuts",
                "Mix in matcha and oats",
                "Form into balls",
                "Roll in coconut"
            ],
            mood: .tired,
            prepTime: "15 mins",
            cookTime: "0 mins",
            servings: 12,
            imageURL: "energy_bites"
        ),
        
        // Stressed Mood Recipes
        Recipe(
            name: "Calming Chamomile Cookies",
            ingredients: ["Flour", "Butter", "Honey", "Chamomile tea", "Lavender", "Vanilla extract"],
            instructions: [
                "Infuse butter with chamomile",
                "Mix ingredients",
                "Form cookies",
                "Bake at 350°F for 10 minutes"
            ],
            mood: .stressed,
            prepTime: "20 mins",
            cookTime: "10 mins",
            servings: 24,
            imageURL: "chamomile_cookies"
        ),
        Recipe(
            name: "Anti-Stress Green Bowl",
            ingredients: ["Kale", "Quinoa", "Almonds", "Avocado", "Blueberries", "Lemon dressing"],
            instructions: [
                "Cook quinoa",
                "Massage kale with olive oil",
                "Assemble bowl with all ingredients",
                "Drizzle with lemon dressing"
            ],
            mood: .stressed,
            prepTime: "15 mins",
            cookTime: "20 mins",
            servings: 2,
            imageURL: "green_bowl"
        )
    ]
} 
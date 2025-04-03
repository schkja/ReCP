import SwiftUI

struct RecipeListView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @State private var showingAddRecipe = false
    @State private var editingRecipe: Recipe?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Mood.allCases, id: \.self) { mood in
                    Section(header: Text("\(mood.icon) \(mood.rawValue)")) {
                        ForEach(viewModel.recipesForMood(mood)) { recipe in
                            RecipeRow(recipe: recipe)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    editingRecipe = recipe
                                }
                        }
                    }
                }
                .onDelete { indexSet in
                    for section in indexSet {
                        let mood = Mood.allCases[section]
                        viewModel.deleteRecipesForMood(mood)
                    }
                }
            }
            .navigationTitle("All Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        editingRecipe = nil
                        showingAddRecipe = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddRecipe) {
                RecipeFormView(viewModel: viewModel)
            }
            .sheet(item: $editingRecipe) { recipe in
                RecipeFormView(viewModel: viewModel, editingRecipe: recipe)
            }
        }
    }
}

struct RecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(recipe.name)
                .font(.headline)
            HStack {
                Text(recipe.prepTime)
                Text("•")
                Text(recipe.cookTime)
                Text("•")
                Text("\(recipe.servings) servings")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
} 
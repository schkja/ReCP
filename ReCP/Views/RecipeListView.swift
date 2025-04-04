import SwiftUI

struct RecipeListView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @State private var showingAddRecipe = false
    @State private var editingRecipe: Recipe?
    @State private var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    var filteredRecipes: [Mood: [Recipe]] {
        var result = [Mood: [Recipe]]()
        
        for mood in Mood.allCases {
            let moodRecipes = viewModel.recipesForMood(mood)
            
            if searchText.isEmpty {
                result[mood] = moodRecipes
            } else {
                let filtered = moodRecipes.filter { recipe in
                    recipe.name.localizedCaseInsensitiveContains(searchText) ||
                    recipe.ingredients.joined().localizedCaseInsensitiveContains(searchText)
                }
                if !filtered.isEmpty {
                    result[mood] = filtered
                }
            }
        }
        
        return result
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppTheme.secondaryText)
                    
                    TextField("Search recipes...", text: $searchText)
                        .font(.system(size: 16))
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppTheme.secondaryText)
                        }
                    }
                }
                .padding(10)
                .background(AppTheme.cardBackground)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Recipe list
                if filteredRecipes.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.secondaryText)
                        
                        Text("No recipes found")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("Try a different search term or add a new recipe")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(Mood.allCases, id: \.self) { mood in
                            if let recipes = filteredRecipes[mood], !recipes.isEmpty {
                                Section {
                                    ForEach(recipes) { recipe in
                                        EnhancedRecipeRow(recipe: recipe)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                editingRecipe = recipe
                                            }
                                    }
                                } header: {
                                    HStack {
                                        Text(mood.icon)
                                            .font(.title3)
                                        Text(mood.rawValue)
                                            .font(.headline)
                                            .foregroundColor(AppTheme.primaryText)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("All Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(AppTheme.primaryText)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        editingRecipe = nil
                        showingAddRecipe = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(AppTheme.accent)
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

struct EnhancedRecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 15) {
            // Recipe image thumbnail - Updated to use RecipeImageView
            RecipeImageView(recipe: recipe, height: 60)
                .frame(width: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 2)
            
            // Recipe details
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.primaryText)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                        Text(recipe.prepTime)
                    }
                    
                    Text("•")
                        .font(.system(size: 10))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                        Text(recipe.cookTime)
                    }
                    
                    Text("•")
                        .font(.system(size: 10))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 10))
                        Text("\(recipe.servings)")
                    }
                }
                .font(.caption)
                .foregroundColor(AppTheme.secondaryText)
            }
            
            Spacer()
            
            // Mood indicator
            Text(recipe.mood.icon)
                .font(.title3)
        }
        .padding(.vertical, 6)
    }
}
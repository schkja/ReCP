import SwiftUI

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditRecipe = false
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Recipe Image
                Image(recipe.imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 20) {
                    // Recipe Name and Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(recipe.name)
                            .font(.title)
                            .bold()
                        
                        HStack {
                            RecipeInfoView(icon: "clock", text: recipe.prepTime)
                            RecipeInfoView(icon: "flame", text: recipe.cookTime)
                            RecipeInfoView(icon: "person.2", text: "\(recipe.servings) servings")
                        }
                    }
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                        
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            Text("• \(ingredient)")
                                .font(.body)
                        }
                    }
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instructions")
                            .font(.title2)
                            .bold()
                        
                        ForEach(Array(recipe.instructions.enumerated()), id: \.element) { index, instruction in
                            Text("\(index + 1). \(instruction)")
                                .font(.body)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingEditRecipe = true
                }) {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showingEditRecipe) {
            RecipeFormView(viewModel: viewModel, editingRecipe: recipe)
        }
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height > 0 {
                        offset = gesture.translation
                    }
                }
                .onEnded { gesture in
                    if gesture.translation.height > 100 {
                        withAnimation(.easeOut(duration: 0.2)) {
                            offset = CGSize(width: 0, height: 1000)
                        }
                        dismiss()
                    } else {
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
                }
        )
    }
} 
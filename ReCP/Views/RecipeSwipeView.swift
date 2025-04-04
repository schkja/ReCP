import SwiftUI

struct RecipeSwipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @State private var offset: CGSize = .zero
    @State private var isShowingRecipe = false
    @State private var isAnimating = false
    @State private var lastViewedRecipe: Recipe?
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            // Current card
            if let recipe = viewModel.currentRecipe {
                RecipeCard(recipe: recipe)
                    .offset(offset)
                    .rotationEffect(.degrees(Double(offset.width / 15)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if !isAnimating {
                                    offset = gesture.translation
                                }
                            }
                            .onEnded { gesture in
                                if !isAnimating {
                                    swipeCard(width: gesture.translation.width)
                                }
                            }
                    )
            } else {
                Text("No recipes available")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.goBack()
                }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .sheet(isPresented: $isShowingRecipe) {
            if let recipe = viewModel.currentRecipe {
                RecipeView(viewModel: viewModel, recipe: recipe)
            }
        }
        .onChange(of: viewModel.currentRecipe) { oldValue, newValue in
            // Reset offset when recipe changes
            withAnimation(.none) {
                offset = .zero
            }
        }
    }
    
    private func swipeCard(width: CGFloat) {
        isAnimating = true
        
        switch width {
        case -500...(-150):
            withAnimation(.easeOut(duration: 0.2)) {
                offset = CGSize(width: -500, height: 0)
            }
            // Get new recipe immediately
            viewModel.getNewRecipe()
            // Reset offset after getting new recipe
            withAnimation(.none) {
                offset = .zero
            }
            isAnimating = false
        case 150...500:
            withAnimation(.easeOut(duration: 0.2)) {
                offset = CGSize(width: 500, height: 0)
            }
            // We no longer need to store lastViewedRecipe since we're not using it
            isShowingRecipe = true
            
            // Reset offset after animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.none) {
                    offset = .zero
                }
                isAnimating = false
            }
        default:
            withAnimation(.spring()) {
                offset = .zero
            }
            isAnimating = false
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Recipe Image - Updated to use RecipeImageView
            RecipeImageView(recipe: recipe, height: 300)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(recipe.name)
                    .font(.title)
                    .bold()
                
                HStack {
                    RecipeInfoView(icon: "clock", text: recipe.prepTime)
                    RecipeInfoView(icon: "flame", text: recipe.cookTime)
                    RecipeInfoView(icon: "person.2", text: "\(recipe.servings) servings")
                }
                
                HStack {
                    Text(recipe.mood.icon)
                        .font(.title2)
                    Text(recipe.mood.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding()
    }
}
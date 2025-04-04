import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void
    @State private var offset = CGSize.zero
    @State private var color: Color = .black
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 0) {
                // Recipe Image - Updated to use RecipeImageView
                RecipeImageView(recipe: recipe, height: 300)
                
                VStack(alignment: .leading, spacing: 12) {
                    // Recipe Name
                    Text(recipe.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Recipe Info
                    HStack {
                        RecipeInfoView(icon: "clock", text: recipe.prepTime)
                        RecipeInfoView(icon: "flame", text: recipe.cookTime)
                        RecipeInfoView(icon: "person.2", text: "\(recipe.servings) servings")
                    }
                    
                    // Mood Indicator
                    HStack {
                        Text(recipe.mood.icon)
                            .font(.title2)
                        Text(recipe.mood.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.white)
            }
            .cornerRadius(20)
        }
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 20)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    withAnimation {
                        color = offset.width > 0 ? .green : .red
                    }
                }
                .onEnded { gesture in
                    withAnimation {
                        swipeCard(width: gesture.translation.width)
                    }
                }
        )
    }
    
    private func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            offset = CGSize(width: -500, height: 0)
            onSwipeLeft()
        case 150...500:
            offset = CGSize(width: 500, height: 0)
            onSwipeRight()
        default:
            offset = .zero
            color = .black
        }
    }
}
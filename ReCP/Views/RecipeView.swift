import SwiftUI

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditRecipe = false
    @State private var offset: CGSize = .zero
    @State private var scrollOffset: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let minY = geometry.frame(in: .global).minY
                Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: minY)
            }
            .frame(height: 0)
            
            VStack(alignment: .leading, spacing: 0) {
                // Recipe Header with Parallax Effect
                ZStack(alignment: .bottom) {
                    // Recipe Image with parallax
                    GeometryReader { geo in
                        let scrollY = geo.frame(in: .global).minY
                        
                        // Updated to use RecipeImageView
                        RecipeImageView(recipe: recipe, height: 350 + (scrollY > 0 ? scrollY : 0))
                            .frame(width: geo.size.width)
                            .offset(y: scrollY > 0 ? -scrollY * 0.5 : 0)
                    }
                    .frame(height: 350)
                    
                    // Gradient overlay for text readability
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.0)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 150)
                    
                    // Recipe title overlay
                    VStack(alignment: .leading, spacing: 8) {
                        // Mood badge
                        HStack {
                            Text(recipe.mood.icon)
                            Text(recipe.mood.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(AppTheme.moodColor(recipe.mood).opacity(0.7))
                        .cornerRadius(20)
                        
                        // Recipe name
                        Text(recipe.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Recipe Info Cards
                VStack(spacing: 16) {
                    // Recipe stats
                    HStack(spacing: 10) {
                        RecipeStatCard(icon: "clock.fill", title: "Prep Time", value: recipe.prepTime)
                        RecipeStatCard(icon: "flame.fill", title: "Cook Time", value: recipe.cookTime)
                        RecipeStatCard(icon: "person.2.fill", title: "Servings", value: "\(recipe.servings)")
                    }
                    .padding(.horizontal)
                    
                    // Ingredients Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "basket.fill")
                                .font(.headline)
                                .foregroundColor(AppTheme.accent)
                            
                            Text("Ingredients")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primaryText)
                        }
                        
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            HStack(alignment: .top, spacing: 12) {
                                Text("•")
                                    .foregroundColor(AppTheme.accent)
                                
                                Text(ingredient)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer() // This ensures the text doesn't expand too far
                            }
                        }
                    }
                    .padding()
                    .background(AppTheme.cardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Instructions Section
                    RecipeSection(title: "Instructions", icon: "list.bullet") {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(Array(recipe.instructions.enumerated()), id: \.element) { index, instruction in
                                HStack(alignment: .top, spacing: 16) {
                                    // Step number
                                    Text("\(index + 1)")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(width: 28, height: 28)
                                        .background(AppTheme.accent)
                                        .clipShape(Circle())
                                    
                                    Text(instruction)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Spacer() // This ensures the text spans the width
                                }
                            }
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                .background(AppTheme.background)
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay(
            VStack {
                // Custom nav bar with animation
                HStack {
                    // Back button
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(scrollOffset < -50 ? AppTheme.primaryText : .white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(scrollOffset < -50 ? AppTheme.cardBackground.opacity(0.9) : Color.black.opacity(0.3))
                            )
                    }
                    
                    Spacer()
                    
                    // Recipe title (shows when scrolled)
                    if scrollOffset < -50 {
                        Text(recipe.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    // Edit button
                    Button(action: {
                        showingEditRecipe = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(scrollOffset < -50 ? AppTheme.primaryText : .white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(scrollOffset < -50 ? AppTheme.cardBackground.opacity(0.9) : Color.black.opacity(0.3))
                            )
                    }
                }
                .padding(.horizontal)
                .frame(height: 60)
                .background(
                    (scrollOffset < -50 ? AppTheme.background : Color.clear)
                        .opacity(scrollOffset < -50 ? 0.9 : 0)
                        .ignoresSafeArea(edges: .top)
                )
                
                Spacer()
            }
            .animation(.easeInOut, value: scrollOffset < -50)
        )
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
        .navigationBarHidden(true)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height > 0 && abs(gesture.translation.width) < abs(gesture.translation.height) {
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
        .sheet(isPresented: $showingEditRecipe) {
            RecipeFormView(viewModel: viewModel, editingRecipe: recipe)
        }
    }
}

// Helper struct for tracking scroll position
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// Recipe statistics card
struct RecipeStatCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(AppTheme.accent)
            
            Text(title)
                .font(.caption)
                .foregroundColor(AppTheme.secondaryText)
            
            Text(value)
                .font(.headline)
                .foregroundColor(AppTheme.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
    }
}

// Recipe section (ingredients, instructions)
struct RecipeSection<Content: View>: View {
    let title: String
    let icon: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(AppTheme.accent)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primaryText)
            }
            
            content()
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
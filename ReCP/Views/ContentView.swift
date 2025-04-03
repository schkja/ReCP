import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var showingRecipeList = false
    @State private var showingAppInfo = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.selectedMood != nil {
                    RecipeSwipeView(viewModel: viewModel)
                } else {
                    MoodSelectionView(viewModel: viewModel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.selectedMood == nil {
                        Button(action: {
                            showingAppInfo = true
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(AppTheme.accent)
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("ReCP")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppTheme.accent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingRecipeList = true
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(AppTheme.accent)
                            
                            if viewModel.selectedMood == nil {
                                Text("All")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.accent)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingRecipeList) {
                RecipeListView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingAppInfo) {
                AppInfoView()
            }
        }
        .preferredColorScheme(colorScheme)
    }
}

struct AppInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Logo
                    VStack {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 70))
                            .foregroundColor(AppTheme.accent)
                            .padding()
                            .background(
                                Circle()
                                    .fill(AppTheme.accent.opacity(0.1))
                                    .frame(width: 150, height: 150)
                            )
                        
                        Text("ReCP")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppTheme.primaryText)
                        
                        Text("Recipe recommendations based on your mood")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    // App Description
                    VStack(alignment: .leading, spacing: 16) {
                        InfoSection(title: "About ReCP", systemImage: "heart.fill") {
                            Text("ReCP helps you decide what to cook based on how you're feeling. Whether you're happy, sad, energetic, tired, or stressed, we've got recipe suggestions for you.")
                                .foregroundColor(AppTheme.primaryText)
                        }
                        
                        InfoSection(title: "How to Use", systemImage: "questionmark.circle.fill") {
                            VStack(alignment: .leading, spacing: 12) {
                                InfoItem(number: 1, text: "Select your current mood from the main screen")
                                InfoItem(number: 2, text: "Swipe through recipe suggestions")
                                InfoItem(number: 3, text: "Swipe right on a recipe to see details")
                                InfoItem(number: 4, text: "Swipe left to see another recipe")
                                InfoItem(number: 5, text: "Tap the list icon to see all recipes")
                            }
                        }
                        
                        InfoSection(title: "Adding Recipes", systemImage: "plus.circle.fill") {
                            Text("To add your own recipes, tap the list icon in the top right corner, then tap the + button.")
                                .foregroundColor(AppTheme.primaryText)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Version info
                    Text("Version 1.0")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                        .padding(.top)
                        .padding(.bottom, 30)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let systemImage: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundColor(AppTheme.accent)
            
            content()
                .font(.subheadline)
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
    }
}

struct InfoItem: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(number)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(AppTheme.accent)
                .clipShape(Circle())
            
            Text(text)
                .foregroundColor(AppTheme.primaryText)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}
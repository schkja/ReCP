import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var showingRecipeList = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.selectedMood != nil {
                    RecipeSwipeView(viewModel: viewModel)
                } else {
                    MoodSelectionView(viewModel: viewModel)
                }
            }
            .navigationTitle("ReCP")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingRecipeList = true
                    }) {
                        Image(systemName: "list.bullet")
                    }
                }
            }
            .sheet(isPresented: $showingRecipeList) {
                RecipeListView(viewModel: viewModel)
            }
        }
    }
} 
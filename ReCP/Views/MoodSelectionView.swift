import SwiftUI

struct MoodSelectionView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @State private var showingAddRecipe = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How are you feeling today?")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    MoodButton(mood: mood) {
                        viewModel.selectMood(mood)
                    }
                }
            }
            .padding()
            
            Spacer()
            
            // Big Add Recipe Button
            Button(action: {
                showingAddRecipe = true
            }) {
                VStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                    Text("Add New Recipe")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .sheet(isPresented: $showingAddRecipe) {
            RecipeFormView(viewModel: viewModel)
        }
    }
}

struct MoodButton: View {
    let mood: Mood
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(mood.icon)
                    .font(.system(size: 40))
                Text(mood.rawValue)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(15)
        }
    }
} 
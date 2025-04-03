import SwiftUI

struct MoodSelectionView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 10) {
                Text("How are you feeling today?")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("Select a mood to find matching recipes")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 25)
            .padding(.bottom, 15)
            
            // Mood Grid
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    EnhancedMoodButton(mood: mood) {
                        viewModel.selectMood(mood)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("ReCP")
    }
}

struct EnhancedMoodButton: View {
    let mood: Mood
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            isPressed = true
            // Provide haptic feedback
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            
            // Reset the pressed state after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isPressed = false
                action()
            }
        }) {
            VStack(spacing: 15) {
                // Emoji with background
                ZStack {
                    Circle()
                        .fill(AppTheme.moodColor(mood).opacity(0.2))
                        .frame(width: 70, height: 70)
                    
                    Text(mood.icon)
                        .font(.system(size: 40))
                }
                
                Text(mood.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.primaryText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppTheme.moodColor(mood).opacity(0.5), lineWidth: 2)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
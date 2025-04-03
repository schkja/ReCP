import SwiftUI

// Color theme that adapts to light/dark mode
struct AppTheme {
    // Main colors
    static let primary = Color("PrimaryColor")
    static let secondary = Color("SecondaryColor")
    static let accent = Color("AccentColor")
    static let background = Color("BackgroundColor")
    static let cardBackground = Color("CardBackgroundColor")
    
    // Text colors
    static let primaryText = Color("PrimaryTextColor")
    static let secondaryText = Color("SecondaryTextColor")
    
    // Mood colors
    static func moodColor(_ mood: Mood) -> Color {
        switch mood {
        case .happy: return Color("HappyColor")
        case .sad: return Color("SadColor")
        case .energetic: return Color("EnergeticColor")
        case .tired: return Color("TiredColor")
        case .stressed: return Color("StressedColor")
        }
    }
}

// Card shapes with custom styling
struct RecipeCardShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerRadius: CGFloat = 20
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        return path
    }
}

// Extending View to add common styling
extension View {
    func cardStyle() -> some View {
        self
            .background(AppTheme.cardBackground)
            .clipShape(RecipeCardShape())
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppTheme.accent)
            .cornerRadius(15)
            .shadow(color: AppTheme.accent.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(AppTheme.accent)
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppTheme.accent.opacity(0.1))
            .cornerRadius(15)
    }
}
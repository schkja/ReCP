import SwiftUI

// Color theme that adapts to light/dark mode
struct AppTheme {
    // Main colors
    static let primary = Color.blue
    static let secondary = Color.gray
    static let accent = Color.orange
    static let background = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    
    // Text colors
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    
    // Mood colors
    static func moodColor(_ mood: Mood) -> Color {
        switch mood {
        case .happy: return Color.green
        case .sad: return Color.blue
        case .energetic: return Color.orange
        case .tired: return Color.gray
        case .stressed: return Color.red
        }
    }
}

// Extending View to add common styling
extension View {
    func cardStyle() -> some View {
        self
            .background(AppTheme.cardBackground)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppTheme.primary)
            .cornerRadius(15)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(AppTheme.primary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppTheme.primary.opacity(0.1))
            .cornerRadius(15)
    }
}
import SwiftUI

struct RecipeInfoView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
} 
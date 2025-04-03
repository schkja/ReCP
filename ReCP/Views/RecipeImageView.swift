import SwiftUI

struct RecipeImageView: View {
    let recipe: Recipe
    let height: CGFloat
    
    var body: some View {
        Group {
            if recipe.isCustomImage {
                if let uiImage = UIImage.loadFromDocuments(fileName: recipe.imageURL) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    // Fallback if image can't be loaded
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .foregroundColor(AppTheme.secondaryText)
                        .background(AppTheme.cardBackground)
                }
            } else {
                // Standard image from asset catalog
                Image(recipe.imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(height: height)
        .clipped()
    }
}
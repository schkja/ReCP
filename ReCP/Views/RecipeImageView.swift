import SwiftUI

struct RecipeImageView: View {
    let recipe: Recipe
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            Group {
                if recipe.isCustomImage {
                    if let uiImage = UIImage.loadFromDocuments(fileName: recipe.imageURL) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: height)
                            .clipped()
                    } else {
                        // Fallback if image can't be loaded
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .foregroundColor(AppTheme.secondaryText)
                            .background(AppTheme.cardBackground)
                            .frame(width: geo.size.width, height: height)
                    }
                } else {
                    // Standard image from asset catalog
                    Image(recipe.imageURL)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: height)
                        .clipped()
                }
            }
        }
        .frame(height: height)
    }
}
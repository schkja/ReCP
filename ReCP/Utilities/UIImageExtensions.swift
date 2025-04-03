import UIKit

// Extension to save UIImage to Documents directory
extension UIImage {
    func saveToDocuments(with name: String) -> String? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let docDirectory = documentsDirectory else { return nil }
        
        let fileName = "\(name)_\(UUID().uuidString).jpg"
        let fileURL = docDirectory.appendingPathComponent(fileName)
        
        guard let data = self.jpegData(compressionQuality: 0.8) else { return nil }
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    static func loadFromDocuments(fileName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let docDirectory = documentsDirectory else { return nil }
        
        let fileURL = docDirectory.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
}
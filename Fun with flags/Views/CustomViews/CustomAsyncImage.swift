//
//  CustomAsyncImage.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 24/10/24.
//

import SwiftUI

/// CustomAsyncImage that gets a URL and does a URLSession request to get image, then locally saves the image - in the future it gets the image from local storage
struct CustomAsyncImage: View {
    let imageURLString: String
    @State private var image: UIImage?
    @State private var isLoading: Bool = true

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Color.gray // Placeholder while loading
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        guard let url = URL(string: imageURLString) else {
            print("Error - bad image URL: \(imageURLString)")
            return
        }
        let localPath = getLocalFilePath(for: url)
        // Load image from local storage if it exists
        if FileManager.default.fileExists(atPath: localPath.path) {
            if let data = try? Data(contentsOf: localPath),
               let savedImage = UIImage(data: data) {
                self.image = savedImage
                self.isLoading = false
            }
        } else {
            // Otherwise download it
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }

                guard let data = data, let downloadedImage = UIImage(data: data) else {
                    print("No data or image could not be created.")
                    return
                }

                // And save the image locally
                if let pngData = downloadedImage.pngData() {
                    try? pngData.write(to: localPath)
                }

                DispatchQueue.main.async {
                    self.image = downloadedImage
                    self.isLoading = false
                }
            }.resume()
        }
    }

    private func getLocalFilePath(for url: URL) -> URL {
        let fileManager = FileManager.default
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cachesDirectory.appendingPathComponent(url.lastPathComponent)
    }
}

//
//  NetworkService.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 22/10/24.
//

import Foundation
import Combine
import UIKit

protocol NetworkServiceProtocol {
    func fetchCountries() -> AnyPublisher<[Country], Error>
}

class NetworkService: NetworkServiceProtocol {
    func fetchCountries() -> AnyPublisher<[Country], Error> {
        let url = URL(string: "https://restcountries.com/v3.1/all?fields=flags,name,region,currencies,languages,capital,capitalInfo")!

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Country].self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { countries in
                countries.forEach { country in
                    if let imageUrl = URL(string: country.flags.png) {
                        let localUrl = country.flags.local
                        self.downloadAndSaveImage(from: imageUrl, to: localUrl)
                    }
                }
            })
            .eraseToAnyPublisher()
    }

    func downloadAndSaveImage(from url: URL, to localUrl: URL) {

        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: localUrl.path) {
            // print("Image already exists at \(localUrl), skipping download.")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                try data.write(to: localUrl)
                // print("Image saved to \(localUrl)")
            } catch {
                print("Error saving image to disk: \(error)")
            }
        }.resume()
    }

}

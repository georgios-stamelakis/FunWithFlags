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
            .eraseToAnyPublisher()
    }

}

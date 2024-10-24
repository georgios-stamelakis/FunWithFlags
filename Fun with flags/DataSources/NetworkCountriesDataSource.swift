//
//  NetworkCountriesDataSource.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 23/10/24.
//

import Foundation
import Combine

protocol NetworkCountriesDataSourceProtocol {
    func getCountries() -> AnyPublisher<[Country], Error>
}

class NetworkCountriesDataSource: NetworkCountriesDataSourceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func getCountries() -> AnyPublisher<[Country], Error> {
        return networkService.fetchCountries()
            .eraseToAnyPublisher()
    }
}

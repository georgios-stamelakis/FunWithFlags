//
//  CountriesRepository.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 22/10/24.
//

import Foundation
import Combine

protocol CountriesRepositoryProtocol {
    func getCountries() -> AnyPublisher<[Country], Error>
}

class CountriesRepository: CountriesRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func getCountries() -> AnyPublisher<[Country], Error> {
        return networkService.fetchCountries()
    }
}

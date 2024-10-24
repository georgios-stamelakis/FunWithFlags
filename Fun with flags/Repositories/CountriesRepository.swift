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
    private let networkDataSource: NetworkCountriesDataSourceProtocol
    private let localDataSource: LocalCountriesDataSourceProtocol
    private let networkMonitor: NetworkMonitor

    init(networkDataSource: NetworkCountriesDataSourceProtocol = NetworkCountriesDataSource(), localDataSource: LocalCountriesDataSourceProtocol = LocalCountriesDataSource(), networkMonitor: NetworkMonitor = NetworkMonitor()) {
        self.networkDataSource = networkDataSource
        self.localDataSource = localDataSource
        self.networkMonitor = networkMonitor
    }

    func getCountries() -> AnyPublisher<[Country], Error> {
        if networkMonitor.isConnected {
            // Fetch from API
            return networkDataSource.getCountries()
                .handleEvents(receiveOutput: { countries in
                    // Save fetched countries to Core Data for offline access
                    self.localDataSource.saveCountriesToCoreData(countries)
                })
                .eraseToAnyPublisher()
        } else {
            // Fetch from Core Data
            return localDataSource.getCountries()
                .eraseToAnyPublisher()
        }
    }
}

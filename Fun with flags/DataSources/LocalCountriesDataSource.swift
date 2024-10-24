//
//  LocalCountriesDataSource.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 23/10/24.
//

import Foundation
import Combine

protocol LocalCountriesDataSourceProtocol {
    func getCountries() -> AnyPublisher<[Country], Error>
    func saveCountriesToCoreData(_ countries: [Country])
}

class LocalCountriesDataSource: LocalCountriesDataSourceProtocol {
    private let coreDataService: CoreDataServiceProtocol

    init(coreDataService: CoreDataServiceProtocol = CoreDataService()) {
        self.coreDataService = coreDataService
    }

    func getCountries() -> AnyPublisher<[Country], Error> {
        let countries = coreDataService.fetchCountriesFromCoreData()
        return Just(countries)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func saveCountriesToCoreData(_ countries: [Country]) {
        coreDataService.saveCountriesToCoreData(countries)
    }
}

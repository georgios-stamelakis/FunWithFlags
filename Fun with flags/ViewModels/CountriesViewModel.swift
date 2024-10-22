//
//  CountriesViewModel.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 21/10/24.
//

import Foundation
import Combine

class CountriesViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var filteredCountries: [Country] = []
    @Published var selectedRegion: String = ""
    @Published var searchText: String = ""
    @Published var regions: [String] = []

    private var cancellables = Set<AnyCancellable>()
    private let repository: CountriesRepositoryProtocol

    init(repository: CountriesRepositoryProtocol = CountriesRepository()) {
        self.repository = repository
        fetchCountries()
    }

    func fetchCountries() {
        repository.getCountries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching countries: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] countries in
                self?.countries = countries
                self?.regions = Array(Set(countries.compactMap { $0.region }))
                self?.filterCountries()
            })
            .store(in: &cancellables)
    }

    func filterCountries() {
        filteredCountries = countries.filter { country in
            (selectedRegion.isEmpty || country.region == selectedRegion) &&
            (searchText.isEmpty || country.name.common.localizedCaseInsensitiveContains(searchText))
        }
    }
}

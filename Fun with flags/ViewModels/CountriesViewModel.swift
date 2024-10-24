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

    @Published var isFetching: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let repository: CountriesRepositoryProtocol

    init(repository: CountriesRepositoryProtocol = CountriesRepository()) {
        self.repository = repository
        fetchCountries()
    }

    func fetchCountries() {

        guard !isFetching else {
                  print("Fetch is already in progress. Skip")
                  return
              }
        isFetching = true

        repository.getCountries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isFetching = false

                switch completion {
                case .failure(let error):
                    print("Error fetching countries: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] countries in
                let sortedCountries = countries.sorted {
                              $0.name.common.localizedCaseInsensitiveCompare($1.name.common) == .orderedAscending
                          }

                self?.countries = sortedCountries
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

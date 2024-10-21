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

    private var cancellable: AnyCancellable?

    init() {
        fetchCountries()
    }

    func fetchCountries() {
        let url = URL(string: "https://restcountries.com/v3.1/all?fields=flags,name,region,currencies,languages,capital,capitalInfo")!

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Country].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .catch { _ in Just([]) }
            .sink { [weak self] countries in
                self?.countries = countries

                let uniqueRegions = Set(countries.compactMap { $0.region })
                self?.regions = Array(uniqueRegions)

                self?.filterCountries()
            }
    }

    func filterCountries() {
        filteredCountries = countries.filter { country in
            (selectedRegion.isEmpty || country.region == selectedRegion) &&
            (searchText.isEmpty || country.name.common.localizedCaseInsensitiveContains(searchText))
        }
    }
}

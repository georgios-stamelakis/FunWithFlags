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
    @Published var searchText = ""

    private var cancellable: AnyCancellable?

    init() {
        fetchCountries()
    }

    func fetchCountries() {
//        let url = URL(string: "https://restcountries.com/v3.1/all")!
        let url = URL(string: "https://restcountries.com/v3.1/all?fields=flags,name,region,currencies,languages,capital,capitalInfo")!

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Country].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .catch { _ in Just([]) }
            .assign(to: \.countries, on: self)
    }

    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.common.lowercased().contains(searchText.lowercased()) }
        }
    }
}

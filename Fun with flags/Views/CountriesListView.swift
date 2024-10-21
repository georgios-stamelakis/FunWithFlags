//
//  CountriesListView.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 21/10/24.
//

import SwiftUI

struct CountriesListView: View {
    @StateObject var viewModel = CountriesViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.filteredCountries) { country in
                NavigationLink(destination: CountryDetailView(country: country)) {
                    HStack {
                        // Flag Section
                        AsyncImage(url: URL(string: country.flags.png)) { image in
                             image
                                 .resizable()
                                 .background(
                                     LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.blue.opacity(0.1)]),
                                                    startPoint: .top,
                                                    endPoint: .bottom)
                                     )
                         } placeholder: {
                             Color.gray
                         }
                         .frame(width: 100, height: 60)
                         .cornerRadius(4)
                         .shadow(radius: 2)
                         .padding(.trailing, 10)

                        // Name and Region
                        VStack(alignment: .leading) {
                            Text(country.name.common)
                            Text(country.region)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Countries")
            .searchable(text: $viewModel.searchText)
        }
    }
}

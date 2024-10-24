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
            VStack {
                HStack {
                    // Picker for selecting regions
                    Picker("Select Region", selection: $viewModel.selectedRegion) {
                        Text("All").tag("")
                        ForEach(viewModel.regions, id: \.self) { region in
                            Text(region).tag(region)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    ZStack(alignment: .trailing) {
                        // Search Bar for country name search
                        TextField("Search Countries", text: $viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .padding(.trailing, 50)

                        // Cancel Search Button
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .padding(.trailing, 8)
                            }
                            .padding(.trailing)
                        }
                    }
                }

                List {
                    if viewModel.filteredCountries.isEmpty {
                        Text("No countries found.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(viewModel.filteredCountries) { country in
                            NavigationLink(destination: CountryDetailView(country: country)) {
                                CountryRow(country: country)
                            }
                        }
                    }
                }
                .navigationTitle("Countries")
                .onChange(of: viewModel.selectedRegion) { _ in
                    viewModel.filterCountries()
                }
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.filterCountries()
                }
                .onAppear {
                    viewModel.fetchCountries()
                }
            }
        }
    }
}

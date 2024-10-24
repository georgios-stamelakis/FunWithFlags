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
                HStack{
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
                                HStack {
                                    // Flag Section
                                    AsyncImage(url: country.flags.local) { image in
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
                                            .foregroundStyle(.secondary)
                                    }
                                }
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

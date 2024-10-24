//
//  CountryDetailView.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 21/10/24.
//

import SwiftUI
import MapKit

struct CountryDetailView: View {
    let country: Country

    @StateObject private var viewModel: CountryDetailViewModel

    init(country: Country) {
        self.country = country
        if let latlng = country.capitalInfo?.latlng, latlng.count == 2 {
            _viewModel = StateObject(wrappedValue: CountryDetailViewModel(lat: latlng[0], lon: latlng[1]))
        } else {
            _viewModel = StateObject(wrappedValue: CountryDetailViewModel(lat: 0.0, lon: 0.0))
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Official Country Name
                Text("\(country.name.official)")
                    .font(.title2)
                    .foregroundStyle(.secondary)

                // Flag Section
                VStack(alignment: .center, spacing: 12) {
                    CustomAsyncImage(imageURLString: country.flags.png)

                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.blue.opacity(0.1)]),
                                           startPoint: .top,
                                           endPoint: .bottom)
                        )
                        .frame(width: 150, height: 90)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                }

                // Country details
                VStack(alignment: .leading, spacing: 8) {
                    Text("**Region:** \(country.region)")
                        .font(.subheadline)
                    Text("**Capital:** \(country.capital?.first ?? "N/A")")
                        .font(.subheadline)
                    Text("**Currency:** \(country.currencies?.first?.value.name ?? "N/A")(\(country.currencies?.first?.value.symbol ?? "N/A"))")
                        .font(.subheadline)
                    Text("**Language\(country.languages?.count ?? 0 > 1 ? "s" : ""):** \(country.languages?.isEmpty == false ? country.languages?.values.joined(separator: ", ") ?? "N/A" : "N/A")")
                        .font(.subheadline)
                }
                .padding(.vertical, 16)

                // Map section
                Divider()
                    .padding(.vertical, 16)

                if let latlng = country.capitalInfo?.latlng, latlng.count == 2 {
                    Text("Location of Capital")
                        .font(.headline)
                        .padding(.bottom, 8)

                    Map(coordinateRegion: .constant(viewModel.region))
                        .frame(height: 300)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
            }
            .padding()
        }
        .navigationTitle(country.name.common)
    }
}

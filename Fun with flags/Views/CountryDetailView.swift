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

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Flag Section
                VStack(alignment: .center, spacing: 12) {
                    AsyncImage(url: URL(string: country.flags.png)) { image in
                        image
                            .resizable()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.blue.opacity(0.1)]),
                                               startPoint: .top,
                                               endPoint: .bottom)
                            )
                    } placeholder: {
                        Color(.gray)
                    }
                    .frame(width: 150, height: 90)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                }

                // Country details
                VStack(alignment: .leading, spacing: 8) {
                    Text("Official Name: \(country.name.official)")
                        .font(.headline)
                    Text("Region: \(country.region)")
                        .font(.subheadline)
                    Text("Capital: \(country.capital?.first ?? "N/A")")
                        .font(.subheadline)
                    Text("Currency: \(country.currencies?.first?.value.name ?? "N/A")(\(country.currencies?.first?.value.symbol ?? "N/A"))")
                        .font(.subheadline)
                    Text("Languages: \(country.languages?.values.joined(separator: ", ") ?? "N/A")")
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

                    Map(coordinateRegion: $region)
                        .frame(height: 300)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .onAppear {
                            DispatchQueue.main.async {
                                region.center = CLLocationCoordinate2D(latitude: latlng[0], longitude: latlng[1])
                            }
                        }
                }
            }
            .padding()
        }
        .navigationTitle(country.name.common)
    }
}

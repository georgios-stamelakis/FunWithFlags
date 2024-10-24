//
//  CountryDetailViewModel.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 21/10/24.
//

import MapKit

class CountryDetailViewModel: ObservableObject {
    private let span = MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)

    @Published var region: MKCoordinateRegion

    init(lat: Double, lon: Double) {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            span: span
        )
    }

    func updateRegion(lat: Double, lon: Double) {
        self.region.center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

}


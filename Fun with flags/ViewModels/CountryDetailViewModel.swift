//
//  CountryDetailViewModel.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 21/10/24.
//

import SwiftUI
import MapKit

class CountryDetailViewModel: ObservableObject {
    @Published var latitude: Double
    @Published var longitude: Double

    private let span = MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)

    var region: MKCoordinateRegion {
          MKCoordinateRegion(
              center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
              span: span
          )
      }

    init(lat: Double, lon: Double) {
        self.latitude = lat
        self.longitude = lon
    }

    func updateRegion(lat: Double, lon: Double) {
        self.latitude = lat
        self.longitude = lon
    }
}

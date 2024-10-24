//
//  CountryRow.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 24/10/24.
//

import SwiftUI

struct CountryRow: View {
    let country: Country

    var body: some View {
        HStack {
            // Flag Section
            CustomAsyncImage(imageURLString: country.flags.png)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.blue.opacity(0.1)]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
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

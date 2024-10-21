//
//  SplashScreenView.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 21/10/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scaleEffect = 0.8

    var body: some View {
        if isActive {
            CountriesListView()
        } else {
            VStack {
                Image(systemName: "flag")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaleEffect(scaleEffect)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0)) {
                            self.scaleEffect = 1.0
                        }
                    }

                Text("Welcome to Fun With Flags")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

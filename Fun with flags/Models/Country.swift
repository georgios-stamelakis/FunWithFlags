//
//  Country.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 21/10/24.
//

import Foundation

struct Country: Decodable, Identifiable {
    let id = UUID()
    let name: Name
    let flags: Flags
    let region: String
    let capital: [String]?
    let currencies: [String: Currency]?
    let languages: [String: String]?
    let capitalInfo: CapitalInfo?

    struct Name: Decodable {
        let common: String
        let official: String
        let nativeName: [String: NativeName]?

        struct NativeName: Decodable {
            let official: String
            let common: String
        }
    }

    struct Flags: Decodable {
        let png: String
        let svg: String
        let alt: String?
    }

    struct Currency: Decodable {
        let name: String
        let symbol: String?
    }

    struct CapitalInfo: Decodable {
        let latlng: [Double]?
    }
}

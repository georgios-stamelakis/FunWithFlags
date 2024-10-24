//
//  Country.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 21/10/24.
//

import Foundation
import CoreData

struct Country: Decodable, Identifiable {
    let id: UUID
    let name: Name
    let flags: Flags
    let region: String
    let capital: [String]?
    let currencies: [String: Currency]?
    let languages: [String: String]?
    let capitalInfo: CapitalInfo?

    init(
        id: UUID,
        name: Name,
        flags: Flags,
        region: String,
        capital: [String]?,
        currencies: [String: Currency]?,
        languages: [String: String]?,
        capitalInfo: CapitalInfo?
    ) {
        self.id = id
        self.name = name
        self.flags = flags
        self.region = region
        self.capital = capital
        self.currencies = currencies
        self.languages = languages
        self.capitalInfo = capitalInfo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = UUID()

        self.name = try container.decode(Name.self, forKey: .name)
        self.flags = try container.decode(Flags.self, forKey: .flags)
        self.region = try container.decode(String.self, forKey: .region)
        self.capital = try container.decodeIfPresent([String].self, forKey: .capital)
        self.currencies = try container.decodeIfPresent([String: Currency].self, forKey: .currencies)
        self.languages = try container.decodeIfPresent([String: String].self, forKey: .languages)
        self.capitalInfo = try container.decodeIfPresent(CapitalInfo.self, forKey: .capitalInfo)
    }

    enum CodingKeys: String, CodingKey {
        case id, 
             name,
             flags,
             region,
             capital,
             currencies,
             languages,
             capitalInfo
    }

    struct Name: Decodable {
        let common: String
        let official: String
    }

    struct Flags: Decodable {
        let png: String
        let svg: String
        let alt: String?
        var local: URL {
            guard let path = URL(string: png)?.lastPathComponent else { return URL(string: "")! }
                let fileManager = FileManager.default
                let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
                let localURL = cachesDirectory.appendingPathComponent(path)
                return localURL
        }
    }

    struct Currency: Decodable {
        let name: String
        let symbol: String?
    }

    struct CapitalInfo: Decodable {
        let latlng: [Double]?
    }
}

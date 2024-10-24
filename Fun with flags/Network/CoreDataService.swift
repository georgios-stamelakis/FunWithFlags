//
//  CoreDataService.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 23/10/24.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func fetchCountriesFromCoreData() -> [Country]
    func saveCountriesToCoreData(_ countries: [Country])
}

class CoreDataService: CoreDataServiceProtocol {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }

    func fetchCountriesFromCoreData() -> [Country] {
        let fetchRequest: NSFetchRequest<CountryEntity> = CountryEntity.fetchRequest()

        do {
            let entities = try coreDataStack.managedContext.fetch(fetchRequest)
            return entities.map { entity in
                return Country(
                    id: entity.id ?? UUID(),
                    name: Country.Name(
                        common: entity.nameCommon ?? "",
                        official: entity.nameOfficial ?? ""
                    ),
                    flags: Country.Flags(
                        png: entity.flagsPng ?? "",
                        svg: entity.flagsSvg ?? "",
                        alt: entity.flagsAlt ?? ""
                    ),
                    region: entity.region ?? "",
                    capital: { 
                        var countryCapitals = [String]()
                        if let capitals = entity.capitalRelationship as? Set<CapitalEntity> {
                            for capital in capitals {
                                countryCapitals.append(capital.name ?? "")
                            }
                        }
                        return countryCapitals
                    }(),
                    currencies: {
                        var countryCurrencies = [String : Country.Currency]()
                        if let currencies = entity.currencyRelationship as? Set<CurrencyEntity> {
                            for currency in currencies {
                                guard let currencyISO = currency.currencyISO, let currencyName = currency.name else { continue }
                                countryCurrencies[currencyISO] = Country.Currency(name: currencyName, symbol: currency.symbol ?? "")
                            }
                        }
                        return countryCurrencies
                    }(),
                    languages: {
                        var countryLanguages = [String: String]()
                        if let languages = entity.languageRelationship as? Set<LanguageEntity> {
                            for language in languages {
                                guard let languageCode = language.code, let languageName = language.language else { continue }
                                countryLanguages[languageCode] = languageName
                            }
                        }
                        return countryLanguages

                    }(),
                    capitalInfo: Country.CapitalInfo(latlng: [entity.capitalLatitude, entity.capitalLongitude])
                )
            }
        } catch {
            print("Failed to fetch countries: \(error)")
            return []
        }
    }

    func saveCountriesToCoreData(_ countries: [Country]) {
        let privateContext = coreDataStack.privateManagedContext
        let context = coreDataStack.managedContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CountryEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try privateContext.execute(deleteRequest)
        } catch {
            print("Failed to delete existing countries: \(error)")
        }

        for country in countries {
            let countryEntity = CountryEntity(context: privateContext)

            countryEntity.id = country.id
            countryEntity.nameCommon = country.name.common
            countryEntity.nameOfficial = country.name.official
            countryEntity.flagsPng = country.flags.png
            countryEntity.flagsSvg = country.flags.svg
            countryEntity.flagsAlt = country.flags.alt ?? ""
            countryEntity.region = country.region
            if let latlng = country.capitalInfo?.latlng, latlng.count == 2 {
                countryEntity.capitalLatitude = latlng[0]
                countryEntity.capitalLongitude = latlng[1]
            } else {
                countryEntity.capitalLatitude = 0
                countryEntity.capitalLongitude = 0
            }

            if let capitals = country.capital {
                for capital in capitals {
                    let newCapitalEntity = CapitalEntity(context: privateContext)
                    newCapitalEntity.name = capital

                    countryEntity.addToCapitalRelationship(newCapitalEntity)
                }
            }

            if let languages = country.languages {
                for language in languages {
                    let newLanguageEntity = LanguageEntity(context: privateContext)
                    newLanguageEntity.code = language.key
                    newLanguageEntity.language = language.value

                    countryEntity.addToLanguageRelationship(newLanguageEntity)
                }
            }

            if let currencies = country.currencies {
                for currency in currencies {
                    let newCurrencyEntity = CurrencyEntity(context: privateContext)
                    newCurrencyEntity.currencyISO = currency.key
                    newCurrencyEntity.name = currency.value.name
                    newCurrencyEntity.symbol = currency.value.symbol ?? ""

                    countryEntity.addToCurrencyRelationship(newCurrencyEntity)
                }
            }
        }

        privateContext.performAndWait {
            if privateContext.hasChanges {
                do {
                    try privateContext.save()
                    context.perform {
                        do {
                            if context.hasChanges {
                                try context.save()
                            }
                            print("Successfully saved in managed context")
                        } catch {
                            print("Error saving managed context: \(error)")
                        }
                    }
                } catch {
                    print("Error saving private context: \(error)")
                }
            }
        }
    }

}

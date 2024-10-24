//
//  CoreDataStack.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 22/10/24.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack(modelName: "CountryDataModel")

    private let modelName: String


    init(modelName: String) {
        self.modelName = modelName
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    lazy var privateManagedContext: NSManagedObjectContext = {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = self.managedContext
        privateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return privateContext
    }()
}

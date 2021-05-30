//
//  DataStack.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//

import Foundation
import CoreData
private let schemaName = "TrackingApp"
private let storeURL = URL.documents.appendingPathComponent("\(schemaName).sqlite")
private let dataContainer: NSPersistentContainer = {
    let omoURL = Bundle.main.url(forResource: "\(schemaName)", withExtension: "omo", subdirectory: "\(schemaName).momd")
    let momURL = Bundle.main.url(forResource: "\(schemaName)", withExtension: "mom", subdirectory: "\(schemaName).momd")
    guard let url = omoURL ?? momURL else { fatalError("model version not found") }
    guard let model = NSManagedObjectModel(contentsOf: url) else { fatalError("cannot open model at \(url)") }
    
    let container = NSPersistentContainer(name: "\(schemaName)", managedObjectModel: model)
    let storeDescription = NSPersistentStoreDescription(url: storeURL)
    print("storeURL:\(storeURL)")
    storeDescription.shouldMigrateStoreAutomatically = false
    container.persistentStoreDescriptions = [storeDescription]
    return container
}()

public func createDataContainer(migrating: Bool = false, progress: Progress? = nil, completion: @escaping (NSPersistentContainer) -> ()) {
    dataContainer.loadPersistentStores { _, error in
        if error == nil {
            dataContainer.viewContext.mergePolicy = NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType
            DispatchQueue.main.async { completion(dataContainer) }
        } else {
            print("Migration failed")
        }
    }
}

extension URL{
    static var documents: URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}

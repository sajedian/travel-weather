//
//  CoreDataHelpers.swift
//  Travel WeatherTests
//
//  Created by Renee Sajedian on 8/2/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import CoreData
import Foundation
@testable import Travel_Weather

class CoreDataHelper {

    class func initializeInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil,
                                                              at: nil, options: nil)
        } catch {
            print("adding in-memory persistent store failed")
        }
        let managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }
}

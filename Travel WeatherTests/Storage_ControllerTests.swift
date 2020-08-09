//
//  StorageController_Tests.swift
//  Travel WeatherTests
//
//  Created by Renee Sajedian on 8/7/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//
import XCTest
import CoreData
import GooglePlaces

@testable import Travel_Weather
//swiftlint:disable type_name
class StorageController_Tests: XCTestCase {

    var storageController: StorageController!

    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TravelWeather")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            assert(description.type == NSInMemoryStoreType)
            if let error = error {
                fatalError("Creating and in-memory coordinator failed")
            }
        }
        return container
    }()

    func clearData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Day")

        do {
            let days = try mockPersistentContainer.viewContext.fetch(fetchRequest)
            for case let day as NSManagedObject in days {
                mockPersistentContainer.viewContext.delete(day)
            }
        } catch let error as NSError {
            fatalError("Failed to clear data, \(error)")
        }
    }

    override func setUpWithError() throws {
        storageController = StorageController(container: mockPersistentContainer)
    }

    override func tearDownWithError() throws {
        clearData()
    }

    func testCreateDefaultDay() {

    }
}

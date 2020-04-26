//
//  StorageController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 3/16/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation
import CoreData


class StorageController {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TravelWeather")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
//            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func getDayForDate(for date: Date) -> Day? {
        let date = date as NSDate
        let context = persistentContainer.viewContext
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
            let predicate = NSPredicate(format: "date == %@", date)
            request.predicate = predicate
            let days = try context.fetch(request)
            if days.isEmpty {
                return nil
            }
            if let day = days[0] as? Day {
                print("Fetched day for \(date)")
                return day
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Could not fetch \(error) \(error.userInfo)")
            return nil
        }
    }
    
    func updateLocationForDay(date: Date, newCity: String, latitude: Double, longitude: Double) {
        print("Updated day for \(date), new city: \(newCity)")
        if let day = getDayForDate(for: date) {
            day.city = newCity
            day.longitude = longitude
            day.latitude = latitude
            day.locationWasSet = true
            saveContext()
        } else {
            createDay(city: newCity, date: date, latitude: latitude, longitude: longitude)
        }
        
    }
    
    func createDay(city: String, date: Date, latitude: Double, longitude: Double) -> Day {
        let context = persistentContainer.viewContext
        let day = Day(entity: Day.entity(), insertInto: context)
        day.city = city
        day.date = date
        day.latitude = latitude
        day.longitude = longitude
        day.locationWasSet = false
        saveContext()
        print("Created Day(date: \(date), city: \(city)")
        return day
    }
    
    
    
    
}



//perform Tasks without blocking the main thread

//container.performBackgroundTask({ (context) in
//  // ... do some task on the context
//
//  // save the context
//  do {
//    try context.save()
//  } catch {
//    // handle error
//  }
//})

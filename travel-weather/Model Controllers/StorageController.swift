//
//  StorageController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 3/16/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation
import CoreData
import GooglePlaces

extension GMSPlace {
    var latitude: Double {
        return Double(coordinate.latitude)
    }
    var longitude: Double {
        return Double(coordinate.longitude)
    }
    var state: String? {
        let stateComponent = addressComponents?.first(where: { (component) -> Bool in
            return component.types.contains("administrative_area_level_1")
        })
        return stateComponent?.name
    }
    
    var shortState: String? {
        let stateComponent = addressComponents?.first(where: { (component) -> Bool in
            return component.types.contains("administrative_area_level_1")
        })
        return stateComponent?.shortName
    }
    
    var country: String? {
        let countryComponent = addressComponents?.first(where: { (component) -> Bool in
            return component.types.contains("country")
        })
        return countryComponent?.name
    }
    
    var shortCountry: String? {
        let countryComponent = addressComponents?.first(where: { (component) -> Bool in
            return component.types.contains("country")
        })
        return countryComponent?.shortName
    }
}

class StorageController {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TravelWeather")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
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
        print("DATE", date)
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
                print(day.location)
                return day
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Could not fetch \(error) \(error.userInfo)")
            return nil
        }
    }

    //does not set locaitonWasSet to true because the day still has the default location
    func updateDefaultLocation(date: Date, newCity: String, latitude: Double, longitude: Double) {
            if let day = getDayForDate(for: date) {
                day.location.latitude = latitude
                day.location.longitude = longitude
                day.location.locality = newCity
                saveContext()
            } else {
                _ = createDay(city: newCity, date: date, latitude: latitude, longitude: longitude)
            }
    }
    
    func updateOrCreateDay(date: Date, place: GMSPlace) {
        let newCity = place.name
        let latitude = place.latitude
        let longitude = place.longitude
        
        if let day = getDayForDate(for: date) {
            day.location.latitude = place.latitude
            day.location.longitude = place.longitude
            day.location.locality = place.name!
            day.location.placeID = place.placeID!
            day.location.country = place.country
            day.location.shortCountry = place.shortCountry
            day.location.state = place.state
            day.location.shortState = place.shortState
            day.locationWasSet = true
            saveContext()
        } else {
            _ = createDay(city: newCity!, date: date, latitude: latitude, longitude: longitude)
        }
        
    }
    
    func createDefaultDay(city: String, date: Date, latitude: Double, longitude: Double) -> Day {
        let context = persistentContainer.viewContext
        let day = Day(entity: Day.entity(), insertInto: context)
        let location = Location(entity: Location.entity(), insertInto: context)
        location.locality = city
        location.longitude = longitude
        location.latitude = latitude
        day.date = date
        day.locationWasSet = false
        day.location = location
        saveContext()
        return day
    }
    
    
    func createDay(city: String, date: Date, latitude: Double, longitude: Double) -> Day {
        let context = persistentContainer.viewContext
        let day = Day(entity: Day.entity(), insertInto: context)
        let location = Location(entity: Location.entity(), insertInto: context)
        location.locality = city
        location.longitude = longitude
        location.latitude = latitude
        day.date = date
        day.locationWasSet = true
        day.location = location
        saveContext()
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

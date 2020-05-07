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

    //does not set locationnWasSet to true because the day still has the default location
    func updateDefaultDay(date: Date, place: GMSPlace) {
            if let day = getDayForDate(for: date) {
                let context = persistentContainer.viewContext
                context.delete(day.location)
                day.location = Location(location: getDefaultLocation(), insertInto: context)
                saveContext()
            } else {
                _ = createDefaultDay(date: date)
            }
    }
    
    func updateOrCreateDay(date: Date, place: GMSPlace) {
        if let day = getDayForDate(for: date) {
            let context = persistentContainer.viewContext
            context.delete(day.location)
            day.location = Location(place: place, insertInto: context)
            day.locationWasSet = true
            saveContext()
            
        } else {
            _ = createDay(date: date, place: place)
        }
        
    }
    
    func createDefaultDay(date: Date) -> Day {
        let context = persistentContainer.viewContext
        let day = Day(entity: Day.entity(), insertInto: context)
        let location = Location(location: getDefaultLocation(), insertInto: context)
        location.defaultLocation = false
        day.date = date
        day.locationWasSet = false
        day.location = location
        saveContext()
        return day
    }
    
    
    func createDay(date: Date, place: GMSPlace) -> Day {
        let context = persistentContainer.viewContext
        let day = Day(entity: Day.entity(), insertInto: context)
        let location = Location(place: place, insertInto: context)
        day.date = date
        day.locationWasSet = true
        day.location = location
        saveContext()
        return day
    }
    
    //creates default location of NYC, could be useful for first launch of app
    private func createDefaultLocation() -> Location {
        let context = persistentContainer.viewContext
        let location = Location(entity: Location.entity(), insertInto: context)
        location.defaultLocation = true
        location.locality = "New York"
        location.country = "United States"
        location.shortCountry = "US"
        location.state = "New York"
        location.shortState = "NY"
        location.latitude = 40.7127753
        location.longitude = -74.0059728
        saveContext()
        return location
    }
    
    func getDefaultLocation() -> Location {
          let context = persistentContainer.viewContext
          do {
              let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
              let predicate = NSPredicate(format: "defaultLocation == YES")
              request.predicate = predicate
              let locations = try context.fetch(request)
              if locations.isEmpty {
                  return createDefaultLocation()
              }
              if let location = locations[0] as? Location {
                  return location
              } else {
                  return createDefaultLocation()
              }
          } catch let error as NSError {
              print("Could not fetch default location \(error) \(error.userInfo)")
              return createDefaultLocation()
          }
    }
    
    func setDefaultLocation(place: GMSPlace) {
        let currentDefault = getDefaultLocation()
        let context = persistentContainer.viewContext
        let newDefault = Location(place: place, insertInto: context)
        newDefault.defaultLocation = true
        context.delete(currentDefault)
        saveContext()
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

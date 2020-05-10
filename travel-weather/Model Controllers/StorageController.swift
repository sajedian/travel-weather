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
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
//    init() {
//        let context = persistentContainer.viewContext
//        if getDefaultLocation() == nil {
//            createDefaultLocation()
//        }
//        saveContext()
//    }

    
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
            let request = Day.dayFetchRequest()
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
    
    //can move declaration of day lower down to avoid problems with creating default and saving context
    func createDefaultDay(date: Date) -> Day {
        let context = persistentContainer.viewContext
        let defaultLocation = getDefaultLocation()
        let day = Day(entity: Day.entity(), insertInto: context)
        day.location = defaultLocation
        day.location.defaultLocation = false
        day.date = date
        day.locationWasSet = false
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
              let request = Location.locationFetchRequest()
              let predicate = NSPredicate(format: "defaultLocation == YES")
              request.predicate = predicate
              let locations = try context.fetch(request)
              if locations.isEmpty {
                  return createDefaultLocation()
              }
              if let location = locations[0] as? Location{
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
        let context = persistentContainer.viewContext
        let currentDefault = getDefaultLocation()
        context.delete(currentDefault)
        let newDefault = Location(place: place, insertInto: context)
        newDefault.defaultLocation = true
        saveContext()
    }
    
    //MARK:- Color Settings
    func createOrUpdateColorSetting(colorHex: String, place: GMSPlace, date: Date) {
        let context = persistentContainer.viewContext
        let location = Location(place: place, insertInto: context)
        let colorSetting = ColorSetting(entity: ColorSetting.entity(), insertInto: context)
        colorSetting.location = location
        colorSetting.placeID = place.placeID!
        colorSetting.colorHex = colorHex
        colorSetting.date = date
        saveContext()
    }
    
    func updateColorSetting(colorHex: String, placeID: String, date: Date) {
        let context = persistentContainer.viewContext
        do {
            let request = ColorSetting.colorSettingFetchRequest()
            let predicate = NSPredicate(format: "placeID == %@", placeID)
            request.predicate = predicate
            let colorSettings = try context.fetch(request)
            if colorSettings.isEmpty{
                print("failed to updateColorSetting")
            } else {
                colorSettings[0].colorHex = colorHex
                saveContext()
            }
        } catch let error as NSError {
           print("Could not update colorSettings: \(error) \(error.userInfo)")
        }
    }
    func getColorSettings() -> [ColorSetting] {
        let context = persistentContainer.viewContext
        var colorSettings = [ColorSetting]()
        do {
            let request = ColorSetting.colorSettingFetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            colorSettings = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch colorSettings \(error) \(error.userInfo)")
        }
        return colorSettings
    }
    
    func getColorSetting(for placeID: String) -> ColorSetting? {
        let context = persistentContainer.viewContext
        var colorSettings = [ColorSetting]()
        do {
            let request = ColorSetting.colorSettingFetchRequest()
            request.predicate = NSPredicate(format: "placeID == %@", placeID)
            colorSettings = try context.fetch(request)
            if colorSettings.isEmpty {
                return nil
            } else {
                return colorSettings[0]
            }
        } catch let error as NSError{
            print("Could not fetch colorSettings \(error) \(error.userInfo)")
            return nil
        }
    }
    
    func deleteColorSetting(colorSetting: ColorSetting) {
        let context = persistentContainer.viewContext
        context.delete(colorSetting.location)
        context.delete(colorSetting)
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

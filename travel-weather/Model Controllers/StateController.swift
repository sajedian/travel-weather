//
//  DayWeatherModelController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 1/25/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//
import UIKit
import Foundation
import GooglePlaces
import CoreData



protocol StateControllerDelegate: class {
    func didUpdateForecast()
}

class StateController: NetworkControllerDelegate {
    
    
    
    init(networkController: NetworkController, storageController: StorageController) {
        self.networkController = networkController
        self.storageController = storageController
        networkController.delegate = self
        createPlaceHolderData()
        colorSettingsArray = storageController.getColorSettings()
    }
    
    private var networkController: NetworkController!
    private var storageController: StorageController!
    weak var delegate: StateControllerDelegate?
    
    
    //MARK:- App State
    private var defaultColor = UIColor(red: 14/255, green: 12/255, blue: 114/255, alpha: 1.0)
//    var colorAssociationsArray: [String] = ["Boston", "Crab Orchard", "Houston"]
    var colorSettingsArray = [ColorSetting]()
    private var days = [Date:Day]()
    var defaultLocation: Location {
        return storageController.getDefaultLocation()!
    }
    //MARK:- Interface
    func getAssociatedColor(for placeID: String) -> UIColor {
        if let colorHex = storageController.getColorSetting(for: placeID)?.colorHex {
            return UIColor(hex: colorHex)!
        }
        else
        if let defaultColor = UIColor(hex: UserDefaults.standard.string(forKey: "defaultColor")!) {
            return defaultColor
        } else {
            return self.defaultColor
        }
    }
    
    func updateAssociatedColor(color: UIColor, for setting: ColorSettingType)  {
        switch setting {
        case .defaultColor:
            UserDefaults.standard.set(color.toHex(), forKey: "defaultColor")
        case .place(let placeID):
            let date = Date()
            storageController.updateColorSetting(colorHex: color.toHex(), placeID: placeID, date: date)
            colorSettingsArray = storageController.getColorSettings()
        }
    }

    func addAssociatedColor(color: UIColor?, for place: GMSPlace) {
        let date = Date()
        if let color = color {
            storageController.createOrUpdateColorSetting(colorHex: color.toHex(), place: place, date: date )
        } else {
            storageController.createOrUpdateColorSetting(colorHex: UserDefaults.standard.string(forKey: "defaultColor")!, place: place, date: date)
        }
        colorSettingsArray = storageController.getColorSettings()
    }
    
    func deleteColorSetting(row index: Int) {
        let colorSetting = colorSettingsArray[index]
        colorSettingsArray.remove(at: index)
        storageController.deleteColorSetting(colorSetting: colorSetting)
    }
    
    func updateForecast() {
        networkController!.requestFullForecast(for: days)
    }

    func getDayForDate(for date: Date) -> Day {
        if let day = days[date] {
            return day
        }
        if let day = storageController.getDayForDate(for: date){
            return day
        } else {
            let newDay = storageController.createDefaultDay(date: date)
            return newDay
        }
    }
    
    func getCityForDate(for date: Date) -> String {
        if let day = storageController.getDayForDate(for: date){
            return day.location.locality
        } else {
            return storageController.getDefaultLocation()!.locality
        }
    }
    
    func locationWasSet(for date: Date) -> Bool {
        if let day = storageController.getDayForDate(for: date) {
            return day.locationWasSet
        } else {
            return false
        }
    }
    
    func updateOrCreateDay(didSelect newLocation: GMSPlace, for date: Date) {
        storageController.updateOrCreateDay(date: date, place: newLocation)
        if let day = days[date] {
            networkController.requestDayForecast(for: day)
        }
    }
    
    func changeDefaultLocation(didSelect newLocation: GMSPlace) {
        storageController.setDefaultLocation(place: newLocation)
        for day in days {
            if !day.value.locationWasSet {
                storageController.updateDefaultDay(date: day.key, place: newLocation)
                networkController.requestDayForecast(for: day.value)
            }
        }
    }
    
    
    

    
    
    //MARK:- NetworkControllerDelegate Functions
    func didUpdateForecast() {
           delegate!.didUpdateForecast()
       }
    
    
    
    
    //-----------------------------------------------------------------------
    //MARK:- Placeholder Data
    
    func dateFromString(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter.date(from: str)!
    }
    
    func createPlaceHolderData() {
        let today = DateHelper.currentDateMDYOnly()
        for i in 0..<14{
            let date = Calendar.current.date(byAdding: .day, value: i, to: today)!
            guard let day = storageController.getDayForDate(for: date) else {
                let day = storageController.createDefaultDay(date: date)
                days[date] = day
                continue
            }
            days[date] = day
        }
        networkController.requestFullForecast(for: days)
    }

    //placeholder associations
   var colorAssociations: [String: UIColor] = [
        "Houston": UIColor(red: 53/255, green: 133/255, blue: 168/255, alpha: 1.0),
        "Chicago": UIColor(red: 113/255, green: 62/255, blue: 224/255, alpha: 1.0),
        "Minneapolis": UIColor(red: 204/255, green: 57/255, blue: 186/255, alpha: 1.0),
        "Rancho Santa Margarita": UIColor(red: 71/255, green: 98/255, blue: 255/255, alpha: 1.0),
        "Philadelphia": UIColor(red: 237/255, green: 177/255, blue: 66/255, alpha: 1.0),
        "Boston": .charcoalGray,
        "New York": UIColor(red: 211/255, green: 88/255, blue: 84/255, alpha: 1.0),
        "Crab Orchard": .mutedPink
    ]
    
    
    
    //placeholder latLong dictionary
    // will later be created by looking up
    var latLongs: [String: (Double, Double)] = [
        "Houston": (29.760427, -95.369804),
        "Chicago": (41.883228, -87.632401),
        "Minneapolis": (44.977753, -93.265015),
        "Rancho Santa Margarita": (33.640670, -117.594550),
        "Philadelphia": (39.951061, -75.165619),
        "Boston": (42.35843, -71.05977),
        "New York": (40.7128, -74.0060)
    ]
}



    

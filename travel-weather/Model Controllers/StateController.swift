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
//        loadAndUpdateData()
        colorSettingsArray = storageController.getColorSettings()
        NotificationCenter.default.addObserver(self, selector: #selector(onTimeChange(_:)), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    private var networkController: NetworkController!
    private var storageController: StorageController!
    weak var delegate: StateControllerDelegate?
    private var timer: Timer?
    
    @ objc func onTimeChange(_ notification: Notification) {
        print("Time Changed")
        loadAndUpdateData()
    }
    
    //MARK:- App State
    private var defaultColor = UIColor(red: 14/255, green: 12/255, blue: 114/255, alpha: 1.0)
//    var colorAssociationsArray: [String] = ["Boston", "Crab Orchard", "Houston"]
    var colorSettingsArray = [ColorSetting]()
    private var days = [Date:Day]()
    var defaultLocation: Location {
        return storageController.getDefaultLocation()
    }
    
    var temperatureUnits: TemperatureUnits {
        return TemperatureUnits(rawValue: UserDefaults.standard.integer(forKey: "temperatureUnits")) ?? .fahrenheit
    }
    //MARK:- Interface
    func startUpdateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer?.tolerance = 10
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    func stopUpdateTimer() {
        timer?.invalidate()
    }
    @objc func fireTimer() {
        print("Updating Data")
        loadAndUpdateData()
    }
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
        networkController.requestFullForecast(for: days)
    }

    func getDayForDate(for date: Date) -> Day {
        if let day = days[date] {
            return day
        }
        else if let day = storageController.getDayForDate(for: date) {
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
            return storageController.getDefaultLocation().locality
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
    
    //should refactor this to do updates locations in batch rather than passing to updateOrCreateDay
    func updateOrCreateDays(didSelect newLocation: GMSPlace, for dates: [Date]) {
        for date in dates {
            updateOrCreateDay(didSelect: newLocation, for: date)
        }
    }
    
    func changeDefaultLocation(didSelect newLocation: GMSPlace) {
        storageController.setDefaultLocation(place: newLocation)
        let defaultDays = days.filter { $0.value.locationWasSet == false }
        storageController.updateDefaultDays(days: defaultDays)
        networkController.requestFullForecast(for: defaultDays)
        
    }
        
    
    
    

    
    
    //MARK:- NetworkControllerDelegate Functions
    func didUpdateForecast() {
//        for (date, day) in days {
//             print("date: ", day.date, "location: ", day.location.locality, "highTemp: ", day.highTemp)
//        }
          storageController.saveContext()
          delegate?.didUpdateForecast()
          
       }
    
    
    
    
    //-----------------------------------------------------------------------
    //MARK:- Placeholder Data
    
    func dateFromString(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter.date(from: str)!
    }
    
    func loadAndUpdateData() {
        let dateThreeDaysAgo = DateHelper.dayFromToday(offset: -3)
        days = days.filter { date, day in
            return date >= dateThreeDaysAgo
        }
        
        for i in 0..<14 {
            let date = DateHelper.dayFromToday(offset: i)
            let day = getDayForDate(for: date)
//            print("date: ", day.date, "location: ", day.location.locality, "highTemp: ", day.highTemp)
            days[date] = day
        }
        storageController.deleteDaysBefore(date: dateThreeDaysAgo)
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



    

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
    }
    
    private var networkController: NetworkController!
    private var storageController: StorageController!
    weak var delegate: StateControllerDelegate?
    
    
    //MARK:- App State
    private var defaultColor = UIColor(red: 14/255, green: 12/255, blue: 114/255, alpha: 1.0)
    var colorAssociationsArray: [String] = ["Boston", "Crab Orchard", "Houston"]
    private var days = [Date:Day]()
    var defaultCity: String {
        if let defaultCity = UserDefaults.standard.string(forKey: "city") {
            return defaultCity
        } else {
            return "No Default Location Set"
        }
    }
    var defaultLatitude: Double {
        return UserDefaults.standard.double(forKey: "latitude")
    }
    var defaultLongitude: Double {
        return UserDefaults.standard.double(forKey: "longitude")
    }
    
    
    
    //MARK:- Interface
    func getAssociatedColor(for city: String) -> UIColor {
        if let associatedColor = colorAssociations[city] {
            return associatedColor
        }
        else if let defaultColor = UIColor(hex: UserDefaults.standard.string(forKey: "defaultColor")!) {
            return defaultColor
        } else {
            return self.defaultColor
        }
    }
    
    func updateAssociatedColor(color: UIColor, for setting: ColorSetting)  {
        switch setting {
        case .defaultColor:
            UserDefaults.standard.set(color.toHex(), forKey: "defaultColor")
        case .city(let city):
            colorAssociations[city] = color
        }
    }
    
    func addAssociatedColor(color: UIColor?, for city: String) {
        colorAssociationsArray = [city] + colorAssociationsArray
        if let color = color {
           colorAssociations[city] = color
        } else {
            colorAssociations[city] = UIColor(hex: UserDefaults.standard.string(forKey: "defaultColor")!)!
        }
        
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
            let defaultCity = UserDefaults.standard.string(forKey: "city")!
            let defaultLatitude = UserDefaults.standard.double(forKey: "latitude")
            let defaultLongitude = UserDefaults.standard.double(forKey: "longitude")
            let newDay = storageController.createDay(city: defaultCity, date: date, latitude: defaultLatitude, longitude: defaultLongitude)
            return newDay
        }
    }
    
    func getCityForDate(for date: Date) -> String {
        if let day = storageController.getDayForDate(for: date){
            return day.location!.locality
        } else if let city = UserDefaults.standard.string(forKey: "city") {
            return city
        } else {
            return "No City Found For Date"
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
        let longitude = Double(newLocation.coordinate.longitude)
        let latitude = Double(newLocation.coordinate.latitude)
        let city = newLocation.name!
        storageController.updateOrCreateDay(date: date, newCity: city, latitude: latitude, longitude: longitude)
        
        if let day = days[date] {
            networkController.requestDayForecast(for: day)
        }
    }
    
    func changeDefaultLocation(didSelect newLocation: GMSPlace) {
        let longitude = Double(newLocation.coordinate.longitude)
        let latitude = Double(newLocation.coordinate.latitude)
        let city = newLocation.name!
        UserDefaults.standard.set(city, forKey: "city")
        UserDefaults.standard.set(longitude, forKey: "longitude")
        UserDefaults.standard.set(latitude, forKey: "latitude")
        for day in days {
            if !day.value.locationWasSet {
                storageController.updateDefaultLocation(date: day.value.date, newCity: city, latitude: latitude, longitude: longitude)
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
    
    private func createPlaceHolderData() {
        let today = DateHelper.currentDateMDYOnly()
        for i in 0..<14{
            let date = Calendar.current.date(byAdding: .day, value: i, to: today)!
            guard let day = storageController.getDayForDate(for: date) else {
                let day = storageController.createDefaultDay(city: defaultCity, date: date, latitude: defaultLatitude, longitude: defaultLongitude)
                days[date] = day
                continue
            }
            days[date] = day
        }
        networkController.requestFullForecast(for: days)
    }
    
    //placeholder associations
    private var colorAssociations: [String: UIColor] = [
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
    private var latLongs: [String: (Double, Double)] = [
        "Houston": (29.760427, -95.369804),
        "Chicago": (41.883228, -87.632401),
        "Minneapolis": (44.977753, -93.265015),
        "Rancho Santa Margarita": (33.640670, -117.594550),
        "Philadelphia": (39.951061, -75.165619),
        "Boston": (42.35843, -71.05977),
        "New York": (40.7128, -74.0060)
    ]
}


    
    
    


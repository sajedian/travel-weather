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
    
    //MARK:- StateController Delegates
    weak var delegate: StateControllerDelegate?
    
    //MARK:- App State
    private var defaultColor = UIColor(red: 14/255, green: 12/255, blue: 114/255, alpha: 1.0)
    var days = [Date:Day]()
    
    
    //MARK:- Interface
    func associatedColor(for day: Day) -> UIColor {
        if let associatedColor = colorAssociations[day.city] {
            return associatedColor
        }
        else {
            return defaultColor
        }
    }

    func updateForecast() {
        networkController!.requestFullForecast(for: days)
    }

    func getDayForDate(for date: Date) -> Day {
        if let day = storageController.getDayForDate(for: date){
            return day
        } else {
            let defaultCity = UserDefaults.standard.string(forKey: "city")!
            let defaultLatitude = UserDefaults.standard.double(forKey: "latitude")
            let defaultLongitude = UserDefaults.standard.double(forKey: "longitude")
            let newDay = storageController.createDay(city: defaultCity, date: date, latitude: defaultLatitude, longitude: defaultLongitude)
            days[date] = newDay
            return newDay
        }
    }
    
    func updateLocationForDate(didSelect newLocation: GMSPlace, for date: Date) {
        let longitude = Double(newLocation.coordinate.longitude)
        let latitude = Double(newLocation.coordinate.latitude)
        let city = newLocation.name!
        storageController.updateLocationForDay(date: date, newCity: city, latitude: latitude, longitude: longitude)
        if let day = days[date] {
            networkController.requestDayForecast(for: day)
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
        let cities = ["Boston", "Philadelphia", "New York", "Rancho Santa Margarita", "Chicago", "Minneapolis", "Houston", "Boston", "Philadelphia", "New York", "Rancho Santa Margarita", "Chicago", "Minneapolis", "Houston"].shuffled()
        let today = DateHelper.currentDateMDYOnly()
//        print("today is \(today)")
        for i in 0..<14{
            let city = cities.randomElement()!
//            print("i is \(i), city is \(city)")
            let date = Calendar.current.date(byAdding: .day, value: i, to: today)!
            let (longitude, latitude) = latLongs[city]!
            guard let day = storageController.getDayForDate(for: date) else {
                let day = storageController.createDay(city: city, date: date, latitude: latitude, longitude: longitude)
                if let latLong = latLongs[city] {
                    (day.latitude, day.longitude) = latLong
                } else {
                    print ("Error: latLong not found for \(city)")
                }
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
        "Boston": UIColor(red: 58/255, green: 142/255, blue: 39/255, alpha: 1.0),
        "New York": UIColor(red: 211/255, green: 88/255, blue: 84/255, alpha: 1.0)
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


    
    
    


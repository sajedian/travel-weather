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



protocol StateControllerDelegate: class {
    func didUpdateForecast()
}

class StateController: NetworkControllerDelegate {
    
    
    init(networkController: NetworkController) {
        self.networkController = networkController
        networkController.delegate = self
        createPlaceHolderData()
    }
    
    private var networkController: NetworkController?
    
    //MARK:- StateController Delegates
    weak var delegate: StateControllerDelegate?
    
    //MARK:- App State
    private var defaultColor = UIColor(red: 14/255, green: 12/255, blue: 114/255, alpha: 1.0)
    var days = [Date: Day]()
    var defaultCity: String = "Boston"
    
    
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
        networkController?.requestFullForecast(for: days)
    }
    
    func getDayForDate(for date: Date) -> Day {
        guard let day = days[date] else {
            let newDay = Day(city: defaultCity, date: date)
            days[date] = newDay
            return newDay
        }
        return day
    }
    
    func updateLocationForDate(didSelect newLocation: GMSPlace, for date: Date) {
        days[date]?.city = newLocation.name!
        days[date]?.latLong = (Double(newLocation.coordinate.latitude), Double(newLocation.coordinate.longitude))
        print(days[date]!.city)
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
        
        for i in 0..<cities.count{
            let city = cities[i]
            let date = dateFromString(str: "2020 02 \(i+10)")
            let day = Day(city: city, date: date)
            if let latLong = latLongs[city] {
                day.latLong = latLong
            } else {
                print ("Error: latLong not found for \(city)")
            }
            days[date] = day
            
        }
        
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


    
    
    


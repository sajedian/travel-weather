//
//  DayWeatherModelController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 1/25/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//
import UIKit

class StateController {
    
    init() {
        
    }
    
    var defaultColor = UIColor(red: 14/255, green: 12/255, blue: 114/255, alpha: 1.0)
    
    //placeholder data
    var dayWeathers = [
        DayWeather(day: .sunday, city: "Boston", highTemp: 72, lowTemp: 35, weatherSummary: .sunny),
        DayWeather(day: .monday, city: "Philadelphia", highTemp: 105, lowTemp: 86, weatherSummary: .cloudy),
        DayWeather(day: .tuesday, city: "New York", highTemp: 35, lowTemp: -20, weatherSummary: .snowy),
        DayWeather(day: .wednesday, city: "Rancho Santa Margarita", highTemp: 105, lowTemp: -34, weatherSummary: .windy),
        DayWeather(day: .thursday, city: "Chicago", highTemp: 2, lowTemp: -3, weatherSummary: .partlyCloudy),
        DayWeather(day: .friday, city: "Minneapolis", highTemp: 44, lowTemp: 35, weatherSummary: .rainy),
        DayWeather(day: .saturday, city: "Houston", highTemp: 109, lowTemp: 2, weatherSummary: .sunny)
    ]
    
    //placeholder associations
    var colorAssociations: [String: UIColor] = [
        "Houston": UIColor(red: 53/255, green: 133/255, blue: 168/255, alpha: 1.0),
        "Chicago": UIColor(red: 113/255, green: 62/255, blue: 224/255, alpha: 1.0),
        "Minneapolis": UIColor(red: 204/255, green: 57/255, blue: 186/255, alpha: 1.0),
        "Rancho Santa Margarita": UIColor(red: 71/255, green: 98/255, blue: 255/255, alpha: 1.0),
        "Philadelphia": UIColor(red: 237/255, green: 177/255, blue: 66/255, alpha: 1.0),
        "Boston": UIColor(red: 58/255, green: 142/255, blue: 39/255, alpha: 1.0),
        "New York": UIColor(red: 211/255, green: 88/255, blue: 84/255, alpha: 1.0)
    ]
    
    
    func associatedColor(for dayWeather: DayWeather) -> UIColor {
        if let associatedColor = colorAssociations[dayWeather.city] {
            return associatedColor
        }
        else {
            return defaultColor
        }
    }
}
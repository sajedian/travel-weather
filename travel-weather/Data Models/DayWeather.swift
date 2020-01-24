//
//  DayWeather.swift
//  travel-weather
//
//  Created by Renee Sajedian on 1/20/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

struct DayWeather {
    
    init(day: Day, city: String, highTemp: Int, lowTemp: Int, weatherSummary: WeatherSummary) {
        self.day = day
        self.city = city
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        self.weatherSummary = weatherSummary
    }
    
    //MARK:- Instance Variables
    var day: Day
    var city: String
    var highTemp: Int
    var lowTemp: Int
    var weatherSummary: WeatherSummary
    var weatherImage: UIImage? {
        return UIImage(systemName: weatherSummary.rawValue)
    }
    var tempDisplay: String? {
        return "\(highTemp) ⏐ \(lowTemp)"
    }
    
    //MARK:- Enums
    //rawValue is systemName of weather icon
    enum WeatherSummary: String {
        case sunny = "sun.max"
        case rainy = "cloud.rain"
        case cloudy = "cloud"
        case partlyCloudy = "cloud.sun"
        case windy = "wind"
        case snowy = "snow"
    }
    
    enum Day: String {
        case sunday = "Sunday"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
    }
    

  
}



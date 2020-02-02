//
//  DayWeather.swift
//  travel-weather
//
//  Created by Renee Sajedian on 1/20/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit
import Foundation

class Day {
    
    init(city: String, date: Date) {
        self.city = city
        self.date = date
    }
    
    //MARK:- Instance Variables
    var city: String
    var date: Date
    var highTemp: Int?
    var lowTemp: Int?
    var weatherSummary: WeatherSummary?
    var weatherImage: UIImage {
        if let weatherSummary = weatherSummary {
            return UIImage(systemName: weatherSummary.rawValue)!
        }
        else {
            return UIImage(systemName: "cloud.fill")!
        }
        
    }
    
    var weekday: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    var tempDisplay: String {
        if let highTemp = highTemp, let lowTemp = lowTemp {
            return "\(highTemp) ⏐ \(lowTemp)"
        } else {
            return "--- ⏐ ---"
        }
        
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
        case other = "cloud.fill"
    }
//
//    enum Weekday: String {
//        case sunday = "Sunday"
//        case monday = "Monday"
//        case tuesday = "Tuesday"
//        case wednesday = "Wednesday"
//        case thursday = "Thursday"
//        case friday = "Friday"
//        case saturday = "Saturday"
//    }
//
    
    func setWeatherForDay(weatherForDay: WeatherForDay) {
        highTemp = Int(weatherForDay.temperatureMax!)
        lowTemp = Int(weatherForDay.temperatureMin!)
    }
  
}



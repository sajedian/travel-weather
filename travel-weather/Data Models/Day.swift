//
//  DayWeather.swift
//  travel-weather
//
//  Created by Renee Sajedian on 1/20/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit
import Foundation

class Dayd {
    
    init(city: String, date: Date) {
        self.city = city
        self.date = date
    }
    
    //MARK:- Instance Variables
    var city: String
    var date: Date
    var highTemp: Int?
    var lowTemp: Int?
    var latLong: (Double, Double)?
    var weatherSummary: WeatherSummary?
    
    
    //MARK:- Enums
    //rawValue is systemName of weather icon
    enum WeatherSummary: String {
        case sunny = "sun.max"
        case rainy = "cloud.rain"
        case cloudy = "cloud"
        case partlyCloudy = "cloud.sun"
        case windy = "wind"
        case snowy = "snow"
        case foggy = "cloud.fog"
        case other = "cloud.fill"
    }


  
}



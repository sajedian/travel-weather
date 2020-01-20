//
//  WeatherList.swift
//  travel-weather
//
//  Created by Renee Sajedian on 1/20/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation

class WeatherList: NSObject {
    
    override init() {
        super.init()
    }
    
    //MARK:- Instance Variables
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
    
}

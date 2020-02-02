//
//  ForecastResult.swift
//  travel-weather
//
//  Created by Renee Sajedian on 2/1/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation


struct ForecastResult: Codable {
    let latitude: Float
    let longitude: Float
    let timezone: String
    let daily: Daily
    
}

struct Daily: Codable {
       let data: [WeatherForDay]
   }

struct WeatherForDay: Codable {
    let time: Int
    let temperatureMax: Double?
    let temperatureMin: Double?
    let icon: String?
}




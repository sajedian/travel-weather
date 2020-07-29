//
//  ForecastResult.swift
//  travel-weather
//
//  Created by Renee Sajedian on 2/1/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation

//used for decoding JSON result from Dark Sky TimeMachine Request
struct ForecastResult: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let daily: Daily?

}
struct Daily: Decodable {
       let data: [WeatherForDay]
   }

struct WeatherForDay: Decodable {
    let time: Int
    let temperatureMax: Double?
    let temperatureMin: Double?
    let icon: String?
}

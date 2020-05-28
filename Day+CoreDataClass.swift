//
//  Day+CoreDataClass.swift
//  travel-weather
//
//  Created by Renee Sajedian on 5/6/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


public class Day: NSManagedObject {
    enum WeatherSummary: String {
        case sunny = "sun.max"
        case rainy = "cloud.rain"
        case cloudy = "cloud"
        case partlyCloudy = "cloud.sun"
        case windy = "wind"
        case snowy = "snow"
        case foggy = "cloud.fog"
        case other = "questionmark.circle"
    }



        var weatherSummary: WeatherSummary? {
              get {
                  if let weatherSummaryValue = weatherSummaryValue {
                      return WeatherSummary(rawValue: weatherSummaryValue)
                  }
                  else {
                      return nil
                  }
                  
              }
              set {
                  self.weatherSummaryValue = newValue?.rawValue
              }
          }
        
        var lowTemp: Int32?
            {
            get {
                self.willAccessValue(forKey: "lowTemp")
                let value = self.primitiveValue(forKey: "lowTemp") as? Int
                self.didAccessValue(forKey: "lowTemp")
                return (value != nil) ? Int32(value!) : nil
            }
            set {
                self.willChangeValue(forKey: "lowTemp")
                let value : Int? = (newValue != nil) ? Int(newValue!) : nil
                self.setPrimitiveValue(value, forKey: "lowTemp")
                self.didChangeValue(forKey: "lowTemp")
            }
        }
        
        var highTemp: Int32?
            {
            get {
                self.willAccessValue(forKey: "highTemp")
                let value = self.primitiveValue(forKey: "highTemp") as? Int
                self.didAccessValue(forKey: "highTemp")
                return (value != nil) ? Int32(value!) : nil
            }
            set {
                self.willChangeValue(forKey: "highTemp")
                let value : Int? = (newValue != nil) ? Int(newValue!) : nil
                self.setPrimitiveValue(value, forKey: "highTemp")
                self.didChangeValue(forKey: "highTemp")
            }
        }
        
        
        //MARK:- Computed Properties
        var weatherImage: UIImage {
            if let weatherSummary = weatherSummary {
                return UIImage(systemName: weatherSummary.rawValue)!
            }
            else {
                //default image is questionmark
                return UIImage(systemName: "questionmark.circle")!
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
        
    var highTempDisplay: String {
        var displayTemp = ""
        if let highTemp = highTemp, let _ = lowTemp {
            if UserDefaults.standard.integer(forKey: "temperatureUnits") == TemperatureUnits.celsius.rawValue {
                let celsius = round((Double(highTemp) - 32.0) * (5.0/9.0))
                displayTemp = String(Int(celsius))
            } else {
                displayTemp = String(highTemp)
            }
            return displayTemp + "°"
        } else {
            return "--- °"
        }
    }
    
    var lowTempDisplay: String {
        var displayTemp = ""
        if let lowTemp = lowTemp, let _ = highTemp {
            if UserDefaults.standard.integer(forKey: "temperatureUnits") == TemperatureUnits.celsius.rawValue {
                let celsius = round((Double(lowTemp) - 32.0) * (5.0/9.0))
                displayTemp = String(Int(celsius))
            } else {
                displayTemp = String(lowTemp)
            }
            return displayTemp + "°"
        } else {
            return "--- °"
        }
    }
        
        //MARK:- Update Forecast Information
        
        
    func setWeatherForDay(weatherForDay: WeatherForDay?, date: String?) {
            if let temperatureMax = weatherForDay?.temperatureMax {
                self.highTemp = Int32(temperatureMax)
            } else {
                self.highTemp = nil
            }
            
            if let temperatureMin = weatherForDay?.temperatureMin {
                self.lowTemp = Int32(temperatureMin)
            } else {
                self.lowTemp = nil
            }
        
        if let date = date {
            self.weatherDataDate = DateHelper.httpDate(from: date)
        } else {
            print("no date found")
        }
            
            
            if let icon = weatherForDay?.icon {
                
                switch icon {
                case "clear-day", "clear-night":
                    weatherSummary = .sunny
                case "cloudy":
                    weatherSummary = .cloudy
                case "partly-cloudy-day", "partly-cloudy-night":
                    weatherSummary = .partlyCloudy
                case "rain", "sleet":
                    weatherSummary = .rainy
                case "snow":
                    weatherSummary = .snowy
                case "fog":
                    weatherSummary = .foggy
                case "wind":
                    weatherSummary = .windy
                default:
                    weatherSummary = .other
                }
            
            } else {
                self.weatherSummary = .other
            }
          
            
        }
        
    }



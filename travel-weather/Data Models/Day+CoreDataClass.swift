//
//  Day+CoreDataClass.swift
//  
//
//  Created by Renee Sajedian on 3/16/20.
//
//

import Foundation
import CoreData
import UIKit

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


public class Day: NSManagedObject {
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
    
//    var longitude: Double?
//           {
//           get {
//               self.willAccessValue(forKey: "longitude")
//               let value = self.primitiveValue(forKey: "longitude") as? Double
//               self.didAccessValue(forKey: "longitude")
//               return (value != nil) ? Double(value!) : nil
//           }
//           set {
//               self.willChangeValue(forKey: "longitude")
//               let value : Double? = (newValue != nil) ? Double(newValue!) : nil
//               self.setPrimitiveValue(value, forKey: "longitude")
//               self.didChangeValue(forKey: "longitude")
//           }
//       }
//    
//    
//    var latitude: Double?
//           {
//           get {
//               self.willAccessValue(forKey: "latitude")
//               let value = self.primitiveValue(forKey: "latitude") as? Double
//               self.didAccessValue(forKey: "latitude")
//               return (value != nil) ? Double(value!) : nil
//           }
//           set {
//               self.willChangeValue(forKey: "latitude")
//               let value : Double? = (newValue != nil) ? Double(newValue!) : nil
//               self.setPrimitiveValue(value, forKey: "latitude")
//               self.didChangeValue(forKey: "latitude")
//           }
//       }
//    
    
    
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
    
    
    //MARK:- Update Forecast Information
    
    
    func setWeatherForDay(weatherForDay: WeatherForDay?) {
        print("Day.city: \(self.city), day.date: \(self.date), temperatureMax: \(weatherForDay?.temperatureMax), temperatureMin: \(weatherForDay?.temperatureMin)")
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
//
//  NetworkController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 2/3/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation



protocol NetworkControllerDelegate: class {
    func didUpdateForecast()
}


class NetworkController {
    
    
    weak var delegate: NetworkControllerDelegate?
    private var dataTask: URLSessionDataTask?
    private let dispatchGroup = DispatchGroup()

    //Interface
    func requestFullForecast(for days: [Date: Day]) {
        for (_, day) in days {
            getDayForecast(for: day)
        }
        dispatchGroup.notify(queue: .main) {
            print("DispathGroup.notify")
            self.delegate?.didUpdateForecast()
        }
    }
    
    func requestDayForecast(for day: Day) {
        getDayForecast(for: day)
        dispatchGroup.notify(queue: .main) {
            self.delegate?.didUpdateForecast()
        }
    }
    
    
    //Internal functions
    
    private func parse(data: Data, day: Day) -> WeatherForDay? {
          do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ForecastResult.self, from:data)
//            print("ForecastResult", result)
            return result.daily?.data[0]
          } catch {
                print("JSON Error: \(error) for day: \(day)")
                return nil
            }
        }
        
    private func composedURL(date: Date, latitude: Double, longitude: Double) -> URL {
        let timeStamp = DateHelper.ISODate(from: date)
        return URL(string: "https://api.darksky.net/forecast/\(darkSkyAPIKey)/\(latitude),\(longitude),\(timeStamp)?exclude=currently,minutely,hourly,alerts,flags")!
    }
    
    private func getDayForecast (for day: Day) {
        dispatchGroup.enter()
        let url = composedURL(date: day.date, latitude: day.location.latitude, longitude: day.location.longitude)
        let session = URLSession.shared
        dataTask = session.dataTask(with: url,
                    completionHandler: { data, response, error in
//                        print("url is \(url)")
                        if let error = error {
                            print("Failure! \(error))")
                        } else if let httpResponse = response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 {
                            if let data = data {
                                let result = self.parse(data: data, day: day)
                                if let weatherForDay = result {
                                  day.setWeatherForDay(weatherForDay: weatherForDay)
                                }
                            }
                            print("Success! \(response!)")
                        } else {
                            print("Failure! \(response!)")
                        }
                        self.dispatchGroup.leave()
                        
        })
        dataTask?.resume()
    }

}

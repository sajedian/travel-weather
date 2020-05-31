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

enum NetworkError: Error {
    case noInternet
    case other
}


class NetworkController {
    
    //MARK:- Properties
    weak var delegate: NetworkControllerDelegate?
    private let session = URLSession.shared
    private let dispatchGroup = DispatchGroup()
    var currentNetworkError: NetworkError? = nil

    
    //MARK:- Interface
    
    //used for getting forecast data for 2 or more days
    func requestFullForecast(for days: [Date: Day]) {
        currentNetworkError = nil
        for (_, day) in days {
            
            guard shouldUpdateData(for: day) else {
                continue
            }
            dispatchGroup.enter()
            getDayForecast2(for: day) { result in
                switch result {
                case .failure(let error):
                    self.currentNetworkError = error
                case .success((let weatherForDay, let date)):
                    DispatchQueue.main.async {
                        day.setWeatherForDay(weatherForDay: weatherForDay, date: date)
                    }
                }
                self.dispatchGroup.leave()
            }
        }
    
        //notifies when all requests have completed
        dispatchGroup.notify(queue: .main) {
            self.delegate?.didUpdateForecast()
        }
    }
    
    //used for requesting forecast data for one day
    func requestDayForecast(for day: Day) {
        dispatchGroup.enter()
        getDayForecast2(for: day) { result in
            switch result {
            case .failure(let error):
                self.currentNetworkError = error
            case .success((let weatherForDay, let date)):
                DispatchQueue.main.async {
                    day.setWeatherForDay(weatherForDay: weatherForDay, date: date)
                }
            }
            self.dispatchGroup.leave()
        }
        //notifies when request has completed
        dispatchGroup.notify(queue: .main) {
            self.delegate?.didUpdateForecast()
        }
    }
    
    
    //MARK:- Private Functions
    
    private func shouldUpdateData(for day: Day) -> Bool {
           //if day is missing temperature information, always request new forecast data
           guard let _ = day.highTemp, let _ = day.lowTemp else {
               return true
           }
           if let dateOfLastUpdate = day.weatherDataDate {
               let timeSinceLastUpdate = DateHelper.timeIntervalToCurrentDate(from: dateOfLastUpdate)
               //request forecast for earlier days more often
               switch DateHelper.daysFromCurrentDate(to: day.date) {
               case 0...1:
                   return timeSinceLastUpdate > 3600 //1 hour
               case 2...3:
                   return timeSinceLastUpdate > 21600 //6 hours
               case 3...5:
                   return timeSinceLastUpdate > 43200 //12 hours
               default:
                   return timeSinceLastUpdate > 86400 //24 hours
               }
           } else {
              return true
           }
           
       }
    
    private func parse(data: Data) -> WeatherForDay? {
          do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ForecastResult.self, from:data)
            return result.daily?.data[0]
          } catch {
                return nil
            }
        }
    
        
    private func composedURLRequest(date: Date, latitude: Double, longitude: Double) -> URLRequest? {
        let timeStamp = DateHelper.ISODate(from: date)
        if let url = URL(string: "https://api.darksky.net/forecast/\(darkSkyAPIKey)/\(latitude),\(longitude),\(timeStamp)?exclude=currently,minutely,hourly,alerts,flags"
            ) {
            return URLRequest(url: url)
        } else {
            return nil
        }
        
    }
    
//    private func getDayForecast(for day: Day) {
//        dispatchGroup.enter()
//        let url = composedURLRequest(date: day.date, latitude: day.location.latitude, longitude: day.location.longitude)!
//        let dataTask = session.dataTask(with: url,
//                    completionHandler: { data, response, error in
//                        if let error = error {
//                            print("Error found\n! \(error), \(response)")
//                        } else if let httpResponse = response as? HTTPURLResponse,
//                            httpResponse.statusCode == 200 {
//                            if let data = data {
//                                let result = self.parse(data: data)
//                                if let weatherForDay = result {
//                                    let date: String? = httpResponse.allHeaderFields["Date"] as? String ?? nil
//                                    DispatchQueue.main.async {
//                                        day.setWeatherForDay(weatherForDay: weatherForDay, date: date)
//                                    }
//                                }
//                            }
//                            print("Success! \(response!)")
//                        } else {
//                            print("Failure! \(response!)")
//                        }
//                        self.dispatchGroup.leave()
//
//        })
//        dataTask.resume()
//    }

    func getDayForecast2(for day: Day, completionHandler: @escaping (Result<(WeatherForDay, String?), NetworkError>) -> Void) {
        
        guard let request = composedURLRequest(date: day.date, latitude: day.location.latitude, longitude: day.location.longitude) else {
            completionHandler(.failure(.other))
            return
        }
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error as? URLError {
                if error.code == .notConnectedToInternet {
                    completionHandler(.failure(.noInternet))
                } else {
                    completionHandler(.failure(.other))
                }
                return
            }
            
            //200 is http status code for OK, meaning the request has succeeded
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completionHandler(.failure(.other))
                return
            }
            
            guard let data = data, let weatherForDay = self.parse(data: data) else {
                completionHandler(.failure(.other))
                return
            }
            let date: String? = httpResponse.allHeaderFields["Date"] as? String ?? nil
            completionHandler(.success((weatherForDay, date)))
            

        }.resume()

    }

}

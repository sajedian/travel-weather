//
//  NetworkController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 2/3/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation



protocol NetworkControllerDelegate: class {
    func receiveUpdatedForecast(day: Day, updatedForecast: WeatherForDay?)
}


class NetworkController {
    
    
    weak var delegate: NetworkControllerDelegate?
    private var dataTask: URLSessionDataTask?

    private func parse(data: Data) -> WeatherForDay? {
          do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ForecastResult.self, from:data)
            return result.daily.data[0]
          } catch {
                print("JSON Error: \(error)")
                return nil
            }
        }
        

    //Interface
    func requestForecast (for day: Day) {
         
        guard let (latitude, longitude) = day.latLong else {
           print("Error: latLong not found for \(day.city)")
            return
        }

        let time = Int(day.date.timeIntervalSince1970)
        print(time)
        let url = URL(string: "https://api.darksky.net/forecast/\(darkSkyAPIKey)/\(latitude),\(longitude),\(time)")!
        let session = URLSession.shared
        dataTask = session.dataTask(with: url,
                    completionHandler: { data, response, error in
                        if let error = error {
                            print("Failure! \(error))")
                        } else if let httpResponse = response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 {
                            if let data = data {
                                let result = self.parse(data: data)
                                DispatchQueue.main.async {
                                    self.delegate?.receiveUpdatedForecast(day: day, updatedForecast: result)
                                }
                            }
                            print("Success! \(response!)")
                        } else {
                            print("Failure! \(response!)")
                        }
        })
        dataTask?.resume()
    }

}
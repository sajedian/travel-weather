//
//  WeatherListViewController.swift
//  Travel Weather
//
//  Created by Renee Sajedian on 1/19/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//


import Foundation
import UIKit



class WeatherListViewController: UITableViewController{
    
    var stateController: StateController!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DayCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DayCell")
        updateForecast()
    }

    
    //MARK:- Table View Data Source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return stateController.days.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayCell
        let day = stateController.days[indexPath.row]
        cell.configureCell(day: day, color: stateController.associatedColor(for: day))
        return cell
    }
    
    
    func parse(data: Data) -> WeatherForDay? {
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(ForecastResult.self, from:data)
        return result.daily.data[0]
      } catch {
            print("JSON Error: \(error)")
            return nil}
    }
    
    var dataTask: URLSessionDataTask?
    
    func updateForecast() {
        stateController.days.forEach { day in
            requestForecast(for: day)
        }
    }
    
    func requestForecast (for day: Day) {
        guard let latLong = stateController.latLongs[day.city] else {
            print("Error: latLong for \(day.city) not found")
            return
        }
        print("latlong: \(latLong)")
        let (latitude, longitude) = latLong
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
                                day.setWeatherForDay(weatherForDay: result!)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
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

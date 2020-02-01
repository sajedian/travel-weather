//
//  WeatherListViewController.swift
//  Travel Weather
//
//  Created by Renee Sajedian on 1/19/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//


import Foundation
import UIKit

class WeatherListViewController: UITableViewController {
    
    var stateController: StateController!


    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DayWeatherCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DayWeatherCell")
        let dayweather = stateController.dayWeathers[1]
        stateController.updateDayWeather(dayweather: dayweather)
    }
    
    //MARK:- Helper Methods
    func requestForecast(with url: URL) -> String? {
      do {
       return try String(contentsOf: url, encoding: .utf8)
      } catch {
       print("Download Error: \(error.localizedDescription)")
    return nil
    } }
    

    
    //MARK:- Table View Data Source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return stateController.dayWeathers.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath) as! DayWeatherCell
        let dayWeather = stateController.dayWeathers[indexPath.row]
        cell.configureCell(dayWeather: dayWeather, color: stateController.associatedColor(for: dayWeather))
        return cell
    }
}

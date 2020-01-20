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
    
    var weatherList = WeatherList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DayWeatherCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DayWeatherCell")
    }
    
    //MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return weatherList.dayWeathers.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath) as! DayWeatherCell
        let dayWeather = weatherList.dayWeathers[indexPath.row]
        cell.configureCell(dayWeather: dayWeather)
        return cell
    }
}

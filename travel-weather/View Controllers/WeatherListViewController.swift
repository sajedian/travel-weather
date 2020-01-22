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
    var colorList = [UIColor(red: 53/255, green: 133/255, blue: 168/255, alpha: 1.0),
                     UIColor(red: 113/255, green: 62/255, blue: 224/255, alpha: 1.0),
                     UIColor(red: 204/255, green: 57/255, blue: 186/255, alpha: 1.0),
                     UIColor(red: 71/255, green: 98/255, blue: 255/255, alpha: 1.0),
                     UIColor(red: 237/255, green: 177/255, blue: 66/255, alpha: 1.0),
                     UIColor(red: 58/255, green: 142/255, blue: 39/255, alpha: 1.0),
                     UIColor(red: 211/255, green: 88/255, blue: 84/255, alpha: 1.0)]

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
        cell.configureCell(dayWeather: dayWeather, color: colorList[indexPath.row])
        return cell
    }
}

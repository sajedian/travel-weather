//
//  DayWeatherCell.swift
//  Travel Weather
//
//  Created by Renee Sajedian on 1/20/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

class DayWeatherCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    func configureCell(dayWeather: DayWeather) {
        dayLabel.text = dayWeather.day.rawValue
        cityLabel.text = dayWeather.city
        tempLabel.text = dayWeather.tempDisplay
        weatherImageView.image = UIImage(systemName: dayWeather.weatherSummary.rawValue)
    }
}

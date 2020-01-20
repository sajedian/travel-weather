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
    
    override func awakeFromNib() {
         super.awakeFromNib()
         let background = UIView(frame: CGRect.zero)
         background.backgroundColor = UIColor(red: 20/255,
             green: 160/255, blue: 160/255, alpha: 0.5)
         backgroundView = background
       }
    
    func configureCell(dayWeather: DayWeather, color: UIColor) {
        dayLabel.text = dayWeather.day.rawValue
        cityLabel.text = dayWeather.city
        tempLabel.text = dayWeather.tempDisplay
        weatherImageView.image = UIImage(systemName: dayWeather.weatherSummary.rawValue)
        let background = UIView(frame: CGRect.zero)
        background.backgroundColor = color
        backgroundView = background
    }
    
}

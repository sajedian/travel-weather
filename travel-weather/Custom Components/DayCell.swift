//
//  DayWeatherCell.swift
//  Travel Weather
//
//  Created by Renee Sajedian on 1/20/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    
    
    
    override func awakeFromNib() {
         super.awakeFromNib()
         colorView.layer.cornerRadius = 10
       }
    
    
    func configureCell(day: Day, color: UIColor) {
        weekdayLabel.text = day.weekday
        cityLabel.text = day.city
        tempLabel.text = day.tempDisplay
        weatherImageView.image = day.weatherImage
        colorView.backgroundColor = color

        
    }
    
    func configureDefaults(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: date)
        weekdayLabel.text = weekday
    }
    
}

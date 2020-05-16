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
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    
    
    @IBOutlet weak var highTempLabel: UILabel!
    
    @IBOutlet weak var lowTempLabel: UILabel!
    
    override func awakeFromNib() {
         super.awakeFromNib()
         colorView.layer.cornerRadius = 11
            colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOffset = CGSize(width: 1, height: 1.5)
            colorView.layer.shadowOpacity = 0.5
        colorView.layer.shadowRadius = 3
        contentView.layer.masksToBounds = false
       }
    
}

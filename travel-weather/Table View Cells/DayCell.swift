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
        colorView.layer.shadowOffset = CGSize(width: 0,  height: 3)
        colorView.layer.shadowOpacity = 0.4
        colorView.layer.shadowRadius = 2
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = false
        colorView.clipsToBounds = false
        colorView.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.masksToBounds = false
       }
    
}

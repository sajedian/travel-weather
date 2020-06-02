//
//  WeatherListCell.swift
//  travel-weather
//
//  Created by Renee Sajedian on 5/29/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit


class WeatherListCell: UITableViewCell {

    @IBOutlet var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = 13
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOffset = CGSize(width: 0,  height: 3)
        colorView.layer.shadowOpacity = 0.4
        colorView.layer.shadowRadius = 2
        colorView.clipsToBounds = false
        colorView.layer.masksToBounds = false
        colorView.backgroundColor = .charcoalGrayLight
        
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = false
        
        clipsToBounds = false
        layer.masksToBounds = false
        backgroundColor = .systemGray6
        
       }
}

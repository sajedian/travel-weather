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
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = false
        colorView.clipsToBounds = false
        colorView.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        backgroundColor = .systemGray6
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

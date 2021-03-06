//
//  ScheduleTableViewCell.swift
//  travel-weather
//
//  Created by Renee Sajedian on 5/28/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .charcoalGrayLight
        locationLabel.textColor = UIColor.white.withAlphaComponent(0.65)
    }
}

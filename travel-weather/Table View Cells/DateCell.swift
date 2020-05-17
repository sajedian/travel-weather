//
//  DateCell.swift
//  travel-weather
//
//  Created by Renee Sajedian on 2/8/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import JTAppleCalendar
import UIKit
class DateCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet var strikeThroughView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dotView.backgroundColor = .darkYellow
        selectedView.layer.cornerRadius = selectedView.bounds.width/2
        selectedView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        strikeThroughView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
}

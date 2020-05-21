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
    @IBOutlet weak var dotView: UIView!
    @IBOutlet var strikeThroughView: UIView!
    var selectedView: UIView!
    
    var selectedLeadingConstraint: NSLayoutConstraint!
    var selectedTrailingConstraint: NSLayoutConstraint!
    
    func createSelectedView() {
        selectedView = UIView()
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(selectedView)
        selectedLeadingConstraint = selectedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        selectedTrailingConstraint = selectedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
            selectedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectedView.heightAnchor.constraint(equalToConstant: 30),
            selectedLeadingConstraint,
            selectedTrailingConstraint
        ])
        selectedView.layer.cornerRadius = (contentView.frame.size.width - 20) / 2.0
        selectedView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        contentView.sendSubviewToBack(selectedView)
        
    }
    
    func selectedViewLeft() {
        selectedTrailingConstraint.constant = 0
        selectedLeadingConstraint.constant = 10
    }
    
    func selectedViewRight() {
        selectedLeadingConstraint.constant = 0
        selectedTrailingConstraint.constant = -10
    }
    
    func selectedViewMiddle() {
        selectedLeadingConstraint.constant = 0
        selectedTrailingConstraint.constant = 0
    }
    
    func selectedViewFull() {
        selectedLeadingConstraint.constant = 10
        selectedTrailingConstraint.constant = -10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createSelectedView()
        dotView.backgroundColor = .darkYellow
        strikeThroughView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
}

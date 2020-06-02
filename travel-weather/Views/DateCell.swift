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
   
    //MARK:- Outlets
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dotView: UIView!
    @IBOutlet var strikeThroughView: UIView!
    
    //MARK:- Properties
    var selectedView: UIView!
    var selectedLeadingConstraint: NSLayoutConstraint!
    var selectedTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createSelectedView()
        dotView.backgroundColor = .darkYellow
        strikeThroughView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    //sets up selected
    private func createSelectedView() {
        
        selectedView = UIView()
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectedView)
        contentView.sendSubviewToBack(selectedView)
        
        selectedLeadingConstraint = selectedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        selectedTrailingConstraint = selectedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
            selectedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectedView.heightAnchor.constraint(equalToConstant: 30),
            selectedLeadingConstraint,
            selectedTrailingConstraint
        ])
        
        selectedView.layer.cornerRadius = (contentView.frame.size.width - 20) / 2.0
        selectedView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        
    }
    //MARK:- Interface
    
    func selectedViewLeft() {
        selectedTrailingConstraint.constant = 0
        selectedLeadingConstraint.constant = 10
        selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    
    func selectedViewRight() {
        selectedLeadingConstraint.constant = 0
        selectedTrailingConstraint.constant = -10
        selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    func selectedViewMiddle() {
        selectedLeadingConstraint.constant = 0
        selectedTrailingConstraint.constant = 0
        selectedView.layer.maskedCorners = []
        
    }
    
    func selectedViewFull() {
        selectedLeadingConstraint.constant = 10
        selectedTrailingConstraint.constant = -10
        selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }

    
    
    
}

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
    
    //MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        createSelectedView()
        dotView.backgroundColor = .darkYellow
        strikeThroughView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    //sets up selectedView which is used when a cell is selected
    //default configuration is a circle, for single cell selection
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
    
    //manipulates constraints to create a solid bar from each cell's selectedView when
    //ranged selection occurs
    //in "full" case selected view is a circle
    
    func selectedViewLeft() {
        selectedTrailingConstraint.constant = 2
        selectedLeadingConstraint.constant = 10
        selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    
    func selectedViewRight() {
        selectedLeadingConstraint.constant = -2
        selectedTrailingConstraint.constant = -10
        selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    func selectedViewMiddle() {
        selectedLeadingConstraint.constant = -2
        selectedTrailingConstraint.constant = 2
        selectedView.layer.maskedCorners = []
        
    }
    func selectedViewFull() {
        selectedLeadingConstraint.constant = 10
        selectedTrailingConstraint.constant = -10
        selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    
    

    
    
    
}

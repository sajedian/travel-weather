//
//  ScheduleListViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 6/8/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

class ScheduleListViewController: UIViewController {
    
    //MARK:- Properties
    var selectedDates: [Date] = [] {
        didSet {
            configureDateLabel()
            tableView.reloadData()
        }
    }
    
    var stateController: StateController!
    
    //MARK: Outlets
    
    @IBOutlet var dateRangeLabel: UILabel!
    @IBOutlet var dateRangeView: UIView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureDateLabel()
        tableView.dataSource = self
        tableView.delegate = self
        
        //view appearance
        view.backgroundColor = .charcoalGray
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        view.layer.cornerRadius = 15
        
        //dateRangeView appearance
        dateRangeView.backgroundColor = .charcoalGray
        dateRangeView.layer.shadowColor = UIColor.black.cgColor
        dateRangeView.layer.shadowRadius = 1.5
        dateRangeView.layer.shadowOpacity = 0.3
        dateRangeView.layer.shadowOffset = CGSize(width: 0, height: 2)
        dateRangeView.layer.cornerRadius = 15
        dateRangeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        //tableView appearance
        tableView.backgroundColor = .charcoalGrayLight
        tableView.layer.cornerRadius = 15
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        


    }
    
    private func configureDateLabel() {
        if selectedDates.isEmpty {
            dateRangeLabel.text = "Select date(s) to view/edit location"
        } else if selectedDates.count == 1 {
            dateRangeLabel.text = selectedDates.first!.monthAndOrdinalDay
        } else {
            dateRangeLabel.text = selectedDates.first!.formatDateRange(to: selectedDates.last!)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ScheduleListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedDates.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleTableViewCell
        let date = self.selectedDates[indexPath.row]
        let dateDisplay = date.shortMonthAndDay
        let locationDisplay = stateController.getLocationDisplay(for: date)
        cell.locationLabel.text = "\(dateDisplay) - \(locationDisplay)"
        return cell
        
    }
    
}

extension ScheduleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = selectedDates[indexPath.row]
        //pushEditLocationVC(dates: [date])
    }
}
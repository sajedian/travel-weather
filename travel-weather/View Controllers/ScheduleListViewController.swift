//
//  ScheduleListViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 6/8/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

protocol ScheduleListViewControllerDelegate: class {
    func didSelectDates(dates: [Date])
}

class ScheduleListViewController: UIViewController {
    
    //MARK:- Properties
    var selectedDates: [Date] = [] {
        didSet {
            configureDateLabel()
            tableView.reloadData()
            if selectedDates.count > 3 {
                tableView.flashScrollIndicators()
            }
            
        }
    }
    
    weak var delegate: ScheduleListViewControllerDelegate?
    var stateController: StateController!
    
    //MARK: Outlets
    
    @IBOutlet var dateRangeLabel: UILabel!
    @IBOutlet var dateRangeView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var indicatorView: UIView!
    
    //MARK:- Actions
    @IBAction func dateRangeViewTapped(_ sender: UITapGestureRecognizer) {
        if selectedDates.isEmpty {
            return
        } else {
            delegate?.didSelectDates(dates: selectedDates)
        }
        
    }
    
    
    //MARK:- Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
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
            indicatorView.isHidden = true
            dateRangeLabel.text = "Select date(s) to view/edit location"
        } else if selectedDates.count == 1 {
            indicatorView.isHidden = false
            dateRangeLabel.text = selectedDates.first!.monthAndOrdinalDay
        } else {
            indicatorView.isHidden = false
            dateRangeLabel.text = selectedDates.first!.formatDateRange(to: selectedDates.last!)
            tableView.flashScrollIndicators()
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
        return selectedDates.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleTableViewCell
        let date = selectedDates[indexPath.row]
        let dateDisplay = date.shortMonthAndDay
        let locationDisplay = stateController.getLocationDisplay(for: date)
        cell.locationLabel.text = "\(dateDisplay) - \(locationDisplay)"
        return cell
        
    }
    
}

extension ScheduleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = selectedDates[indexPath.row]
        delegate?.didSelectDates(dates: [date])
    }
}

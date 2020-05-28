//
//  WeatherListViewController.swift
//  Travel Weather
//
//  Created by Renee Sajedian on 1/19/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//


import Foundation
import UIKit



class WeatherListViewController: UITableViewController {

    var stateController: StateController! {
        didSet {
            stateController.weatherListDelegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.clipsToBounds = false
        let cellNib = UINib(nibName: "DayCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DayCell")
        tableView.reloadData()
        
    }
    
    func configureCell(day: Day, cell: DayCell) {
        cell.weekdayLabel.text = day.weekday
        cell.dateLabel.text = DateHelper.shortDateFormat(date: day.date)
        cell.cityLabel.text = day.location.display
        cell.lowTempLabel.text = day.lowTempDisplay
        cell.highTempLabel.text = day.highTempDisplay
        cell.weatherImageView.image = day.weatherImage
        cell.colorView.backgroundColor = stateController.getAssociatedColor(for: day.location.placeID)
    }
        
    
    
    
    //MARK:- Table View Data Source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayCell
        let date = DateHelper.dayFromToday(offset: indexPath.row)
        let day = stateController.getDayForDate(for: date)
        configureCell(day: day, cell: cell)
        return cell
    }
    
   
}

extension WeatherListViewController: StateControllerDelegate {
    func didUpdateForecast() {
        tableView.reloadData()
    }

}


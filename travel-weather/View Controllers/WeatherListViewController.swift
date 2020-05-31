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
    
    var numberOfRows = 15
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.clipsToBounds = false
        tableView.backgroundColor = .systemGray6
        
        var cellNib = UINib(nibName: "DayCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DayCell")
        cellNib = UINib(nibName: "DarkSkyAttributionCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "AttributionCell")
        tableView.register(UINib.init(nibName: "NoInternetCell", bundle: nil), forCellReuseIdentifier: "NoInternetCell")
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
        if stateController.networkError != nil {
            numberOfRows = 16
        } else {
            numberOfRows = 15
        }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //offset determines which date corresponds to a cell
        let offset: Int
        //show no internet cell if there's a network error
        if stateController.networkError != nil {
            //adjust offset due to extra cell at top of table
            offset = indexPath.row - 1
            if indexPath.row == 0 {
                return tableView.dequeueReusableCell(withIdentifier: "NoInternetCell", for: indexPath) as! WeatherListCell
            }
        } else {
            offset = indexPath.row
        }
        //last cell is Dark Sky attribution cell
        if indexPath.row == numberOfRows - 1 {
            return tableView.dequeueReusableCell(withIdentifier: "AttributionCell", for: indexPath) as! WeatherListCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayCell
            let date = DateHelper.dayFromToday(offset: offset)
            let day = stateController.getDayForDate(for: date)
            configureCell(day: day, cell: cell)
            return cell
        }
    }
    
    
    //MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == numberOfRows - 1 {
            if let url = URL(string: "https://darksky.net/poweredby/") {
                UIApplication.shared.open(url)
            }
        }
    }
   
}

extension WeatherListViewController: StateControllerDelegate {
    func didUpdateForecast() {
        tableView.reloadData()
    }

}


//
//  WeatherListViewController.swift
//  Travel Weather
//
//  Created by Renee Sajedian on 1/19/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//


import Foundation
import UIKit



class WeatherListViewController: UITableViewController, StateControllerDelegate{

    
    
    var stateController: StateController! {
        didSet {
            stateController.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stateController.updateForecast()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DayCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DayCell")
        tableView.reloadData()
    }
    
    func didUpdateForecast() {
            tableView.reloadData()
            print("reloaded data")
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
        if let day = day {
            cell.configureCell(day: day, color: stateController.associatedColor(for: day))
        }
        else  {
            cell.configureDefaults(date: date)
        }
        return cell
    }
    
   
}


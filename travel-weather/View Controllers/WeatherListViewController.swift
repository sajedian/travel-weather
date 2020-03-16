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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DayCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DayCell")
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
        let date = stateController.dateFromString(str: "2020 02 \(indexPath.row + 10)")
        let day = stateController.getDayForDate(for: date)
        cell.configureCell(day: day, color: stateController.associatedColor(for: day))
        return cell
    }
    

   
}

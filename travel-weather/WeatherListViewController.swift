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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DayWeatherCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DayWeatherCell")
    }
    
    //MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath)
        return cell
    }
}

//
//  ColorSettingsViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 4/29/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation
import UIKit

class ColorSettingsViewController: UITableViewController {
    
    var stateController: StateController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Outlets
    
    
    //MARK:- Actions
    @IBAction func cancel() {
           navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorSettingsCell", for: indexPath) as! ColorSettingsCell
        cell.cityLabel?.text = "Default Color"
        cell.colorImageView?.tintColor = UIColor(red: 0/255, green: 204/255, blue: 122/255, alpha: 1.0)
        return cell
    }
}

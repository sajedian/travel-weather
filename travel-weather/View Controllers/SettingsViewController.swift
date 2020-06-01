//
//  SettingsViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 4/5/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//


import UIKit
import GooglePlaces

enum TemperatureUnits: Int {
    case celsius //0
    case fahrenheit //1
}

class SettingsViewController: UITableViewController {
    
    //MARK:- Properties
    var stateController: StateController!
    
    
    //MARK:- Outlets
    @IBOutlet var temperatureUnitControl: UISegmentedControl!
    @IBOutlet var defaultCityLabel: UILabel!
    
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultCityLabel.text = stateController.defaultLocation.display
        if UserDefaults.standard.integer(forKey: "temperatureUnits") == TemperatureUnits.celsius.rawValue {
            temperatureUnitControl.selectedSegmentIndex = 0
        } else {
            temperatureUnitControl.selectedSegmentIndex = 1
        }
    }
    

    //MARK:- Actions
    
    //@IBAction func unwindToSettingsVC(segue: UIStoryboardSegue) {}
    
    @IBAction func temperatureUnitsChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UserDefaults.standard.set(TemperatureUnits.celsius.rawValue, forKey: "temperatureUnits")
        } else {
            UserDefaults.standard.set(TemperatureUnits.fahrenheit.rawValue, forKey: "temperatureUnits")
        }
    }
    
    
    //MARK:- Table View Data Source
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        let footerLabel = UILabel()
        footerView.addSubview(footerLabel)
        
        footerLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        footerLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        footerLabel.textColor = UIColor.systemGray
        footerLabel.text = self.tableView(tableView, titleForFooterInSection: section)
       
        return footerView
    }
    
   
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
       
        switch section {
        case 0:
            return "Set location where you'll be most often"
        case 1:
            return "Set colors for Forecast display"
        default:
            return nil
        }

    }
    
    
    //MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDefaultLocation" {
            let controller = segue.destination as! EditLocationViewController
            controller.title = "Set Home Location"
            controller.delegate = self
        }
        else if segue.identifier == "colorSettings" {
            let controller = segue.destination as! ColorSettingsViewController
            controller.stateController = stateController
        }
       }

    
}

extension SettingsViewController: EditLocationViewControllerDelegate {

    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for date: [Date]?) {
        
        navigationController?.popViewController(animated: true)
        stateController.changeDefaultLocation(didSelect: newLocation)
        defaultCityLabel.text = stateController.defaultLocation.display
    }
}

//
//  SettingsViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 4/5/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//


import UIKit
import GooglePlaces

class SettingsViewController: UITableViewController {
    
    var stateController: StateController!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        defaultCityLabel.text = stateController.defaultCity
    }
    
    @IBOutlet weak var defaultCityLabel: UILabel!
    @IBAction func unwindToSettingsVC(segue: UIStoryboardSegue) {}
    
    
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        
        myLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        myLabel.textColor = UIColor.systemGray
        myLabel.text = self.tableView(tableView, titleForFooterInSection: section)

        let footerView = UIView()
//        footerView.backgroundColor = UIColor.lightGray
        footerView.addSubview(myLabel)

        return footerView
    }
    
    // Create a standard footer that includes the returned text.
    override func tableView(_ tableView: UITableView, titleForFooterInSection
                                section: Int) -> String? {
        if section == 0 {
           return "Set location where you'll be most often"
        } else {
            return nil
        }
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDefaultLocation" {
            let controller = segue.destination as! EditLocationViewController
            controller.title = "Set Default Location"
            controller.delegate = self
        }
        else if segue.identifier == "colorSettings" {
            let controller = segue.destination as! ColorSettingsViewController
            controller.stateController = stateController
        }
       }

    
}

extension SettingsViewController: EditLocationViewControllerDelegate {
    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for date: Date?) {
        navigationController?.popViewController(animated: true)
        stateController.changeDefaultLocation(didSelect: newLocation)
        defaultCityLabel.text = stateController.defaultCity
    }
}

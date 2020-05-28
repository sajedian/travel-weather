//
//  ColorSettingsViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 4/29/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

enum ColorSettingType {
    case defaultColor
    case place(placeID: String)
}

class ColorSettingsViewController: UITableViewController {
    
    var stateController: StateController!
    var selectedSetting: ColorSettingType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK:- Outlets
    
    
    //MARK:- Actions
    @IBAction func cancel() {
           navigationController?.popViewController(animated: true)
    }
    @IBAction func unwindToColorSettingsVC(segue: UIStoryboardSegue) {
            
    }
    
    //MARK:- Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return stateController.colorSettingsArray.count
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "colorSettingsCell", for: indexPath)
            cell.textLabel?.text = "Default Color"
            cell.imageView?.tintColor = UIColor(hex: UserDefaults.standard.string(forKey: "defaultColor")!)!
            return cell
        case (1, 0):
            return tableView.dequeueReusableCell(withIdentifier: "addLocationCell", for: indexPath)
        case (2, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "colorSettingsCell", for: indexPath)
            let index = indexPath.row
            let city = stateController.colorSettingsArray[index].location.locality
            let state = stateController.colorSettingsArray[index].location.shortState ?? ""
            let hexColor = stateController.colorSettingsArray[index].colorHex
            cell.textLabel?.text = city + ", " + state
            cell.imageView?.tintColor = UIColor(hex: hexColor)
            return cell
        default:
            print("Error, cell not found")
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 25
        } else {
            return 35
        }
    }
    
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
            
            switch section {
            case 0:
                return "Set default color for Forecast display"
            case 1:
                return "Add a corresponding color for a location"
            default:
                return nil
            }

        }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stateController.deleteColorSetting(row: indexPath.row) //write this method
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    //MARK:- Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
         if segue.identifier == "addLocation" {
            let controller = segue.destination as! EditLocationViewController
            controller.title = "Add Location"
           controller.delegate = self
         }
         else if segue.identifier == "colorPicker" {
            let controller = segue.destination as! ColorPickerViewController
            if selectedPath.section == 0 {
                controller.selectedSetting = .defaultColor
                controller.title = "Default Color"
            } else {
                let city = self.stateController.colorSettingsArray[selectedPath.row].location.locality
                
                let placeID = self.stateController.colorSettingsArray[selectedPath.row].placeID
                controller.title = city
                controller.selectedSetting = .place(placeID: placeID)
            }
            controller.stateController = stateController
         }
        }

}

extension ColorSettingsViewController: EditLocationViewControllerDelegate {
    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for dates: [Date]?) {
        stateController.addAssociatedColor(color: nil , for: newLocation)
        performSegue(withIdentifier: "colorPicker", sender: tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 2)))
    }

}

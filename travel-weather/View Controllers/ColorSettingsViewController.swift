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

enum ColorSetting {
    case defaultColor
    case city(String)
}

class ColorSettingsViewController: UITableViewController {
    
    var stateController: StateController!
    var selectedSetting: ColorSetting?
    
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
            return stateController.colorAssociationsArray.count
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
            let city = stateController.colorAssociationsArray[index]
            let color = stateController.getAssociatedColor(for: city)
            cell.textLabel?.text = city
            cell.imageView?.tintColor = color
            return cell
        default:
            print("Error, cell not found")
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 1
        } else {
            return 20
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt")
//        switch (indexPath.section, indexPath.row) {
//        case(0, 0):
//            selectedSetting = .defaultColor
//        case (2, _):
//            selectedSetting = .city(stateController.colorAssociationsArray[indexPath.row])
//        default:
//            selectedSetting = nil
//        }
//        print(selectedSetting)
//    }
            

    //MARK:- Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
         if segue.identifier == "addLocation" {
             let controller = segue.destination as! EditLocationViewController
             controller.delegate = self
         }
         else if segue.identifier == "colorPicker" {
            let controller = segue.destination as! ColorPickerViewController
            if selectedPath.section == 0 {
                controller.selectedSetting = .defaultColor
            } else {
                controller.selectedSetting = .city(stateController.colorAssociationsArray[selectedPath.row])
            }
            controller.stateController = stateController
         }
        }

}

extension ColorSettingsViewController: EditLocationViewControllerDelegate {
    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for date: Date?) {
        
    }

}

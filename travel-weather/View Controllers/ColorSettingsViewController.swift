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

    // MARK: - Properties
    var stateController: StateController!
    var selectedSetting: ColorSettingType?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Actions
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func unwindToColorSettingsVC(segue: UIStoryboardSegue) {}

    // MARK: - Table View Data Source

    //Table View Cells
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
            cell.imageView?.tintColor = stateController.defaultColor
            return cell
        case (1, 0):
            return tableView.dequeueReusableCell(withIdentifier: "addLocationCell", for: indexPath)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "colorSettingsCell", for: indexPath)
            let index = indexPath.row
            let location = stateController.colorSettingsArray[index].location
            let hexColor = stateController.colorSettingsArray[index].colorHex
            cell.textLabel?.text = location.display
            cell.imageView?.tintColor = UIColor(hex: hexColor)
            return cell
        }
    }

    //Footers
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 25
        } else {
            return 35
        }
    }

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
            return "Set default color for Forecast display"
        case 1:
            return "Add a corresponding color for a location"
        default:
            return nil
        }

    }

    //Enable swipe-to-delete
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stateController.deleteColorSetting(row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let selectedPath = tableView.indexPathForSelectedRow else { return }

        if segue.identifier == "addLocation" {
            guard let controller = segue.destination as? EditLocationViewController else {
                fatalError("Failed to segue from ColorSettingsVC to EditLocationVC")
            }
            controller.title = "Add Location"
            controller.delegate = self
        } else if segue.identifier == "colorPicker" {
            guard let controller = segue.destination as? ColorPickerViewController else {
                fatalError("Failed to segue from ColorSettingsVC to ColorPickerVC")
            }
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
        stateController.addAssociatedColor(color: nil, for: newLocation)
        performSegue(withIdentifier: "colorPicker",
                     sender: tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 2)))
    }

}

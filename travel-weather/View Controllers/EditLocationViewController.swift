//
//  EditLocationViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 2/28/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit
import GooglePlaces

protocol EditLocationViewControllerDelegate {
    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for dates: [Date]?)
}

class EditLocationViewController: UIViewController{
    
    //MARK:- Outlets
    @IBOutlet weak var subView: UIView!
    
    //MARK:- Properties
    var delegate: EditLocationViewControllerDelegate?
    var dates: [Date] = []
    var searchController: UISearchController!
    var resultsViewController: GMSAutocompleteResultsViewController!
    var resultView: UITextView?
    
    
    //MARK:- Actions
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !dates.isEmpty {
            if dates.count > 1 {
                title = DateHelper.formatDateRange(date1: dates.first!, date2: dates.last!)
            } else {
                title = DateHelper.monthAndDayFromDate(from: dates.first!)
            }
        }
        
        
        navigationController?.navigationBar.isTranslucent = false
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
       
        //create controller for displaying autocomplete results
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = self
        resultsViewController.edgesForExtendedLayout = []
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.hidesNavigationBarDuringPresentation = false
        
        
        //configure filtering to only present cities
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        resultsViewController.autocompleteFilter = filter
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.addressComponents.rawValue)
            | UInt(GMSPlaceField.coordinate.rawValue) )!
        resultsViewController.placeFields = fields
        searchController.searchResultsUpdater = resultsViewController
        
        //move search content down so it isn't cut off by search bar
        searchController.searchResultsController?.additionalSafeAreaInsets = UIEdgeInsets.init(top: 60, left: 0, bottom: 0, right: 0)
        
        //adds search bar to search controller and configure its appearance
        let searchBar = searchController.searchBar
        subView.addSubview(searchBar)
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.showsCancelButton = false
        searchBar.searchTextField.placeholder = "Search for new location"
        searchBar.searchTextField.textColor = UIColor.charcoalGray
        searchBar.searchTextField.backgroundColor = UIColor.systemGray6
    }
    
}


// Handle the user's selection.
extension EditLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
 
    
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    searchController.isActive = false
    searchController.dismiss(animated: true, completion: {
        self.delegate?.editLocationViewControllerDidUpdate(didSelect: place, for: self.dates)
        })
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

}

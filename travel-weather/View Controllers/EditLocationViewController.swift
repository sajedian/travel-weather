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
    
    var delegate: EditLocationViewControllerDelegate?
    var dates: [Date] = []
    var searchController: UISearchController!
    var resultsViewController: GMSAutocompleteResultsViewController!
    
    var resultView: UITextView?
    
    @IBOutlet weak var subView: UIView!
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
       }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !dates.isEmpty {
            if dates.count > 1 {
                title = DateHelper.formatDateRange(date1: dates.first!, date2: dates.last!)
            } else {
                title = DateHelper.monthAndDayFromDate(from: dates.first!)
            }
        }
       
        resultsViewController = GMSAutocompleteResultsViewController()
        searchController = UISearchController(searchResultsController: resultsViewController)
    
        resultsViewController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        resultsViewController.autocompleteFilter = filter
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.addressComponents.rawValue)
            | UInt(GMSPlaceField.coordinate.rawValue) )!
        resultsViewController.placeFields = fields

        searchController.searchResultsUpdater = resultsViewController
        
        subView.addSubview((searchController.searchBar))
        searchController.searchBar.sizeToFit()
        searchController.searchBar.isTranslucent = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        searchController.searchBar.showsCancelButton = false
        resultsViewController.edgesForExtendedLayout = []
        searchController.searchResultsController?.additionalSafeAreaInsets = UIEdgeInsets.init(top: 64, left: 0, bottom: 0, right: 0)
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.searchTextField.placeholder = "Search for new location"
        searchController.searchBar.searchTextField.textColor = UIColor.charcoalGrayDark
        searchController.searchBar.searchTextField.backgroundColor = UIColor.systemGray6

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

//  // Turn the network activity indicator on and off again.
//  func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = true
//  }
//
//  func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//  }


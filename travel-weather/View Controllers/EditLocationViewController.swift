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
    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for date: Date)
    func editLocationViewControllerDidCancel()
}

class EditLocationViewController: UIViewController{
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    @IBOutlet weak var subView: UIView?
    
    @IBAction func cancel() {
           delegate?.editLocationViewControllerDidCancel()
       }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        title = dateFormatter.string(from: self.date)
    
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        resultsViewController?.autocompleteFilter = filter

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        


        subView!.addSubview((searchController?.searchBar)!)
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.isTranslucent = false
        searchController?.hidesNavigationBarDuringPresentation = false
        
        navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        searchController?.searchBar.showsCancelButton = false
        resultsViewController?.edgesForExtendedLayout = []
        searchController?.searchResultsController?.additionalSafeAreaInsets = UIEdgeInsets.init(top: 64, left: 0, bottom: 0, right: 0)
        searchController?.searchBar.backgroundImage = UIImage()
        

    }
    
    var delegate: EditLocationViewControllerDelegate?
    var date: Date!
    
    

}


// Handle the user's selection.
// Handle the user's selection.
extension EditLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    searchController?.isActive = false
    delegate?.editLocationViewControllerDidUpdate(didSelect: place, for: date)
    searchController?.dismiss(animated: false, completion: {self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)})
    
    
//    DispatchQueue.main.async {
//        self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
//    }
    
  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

//  // Turn the network activity indicator on and off again.
//  func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = true
//  }
//
//  func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//  }
}

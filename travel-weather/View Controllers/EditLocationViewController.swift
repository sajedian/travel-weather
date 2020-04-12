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
    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for date: Date?)
    func editLocationViewControllerDidCancel()
}

class EditLocationViewController: UIViewController{
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    @IBOutlet weak var subView: UIView?
    var date: Date?
    var unwindIdentifier: String?
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
       }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let date = self.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d"
            title = dateFormatter.string(from: date)
        } else {
            title = "Edit Default Location"
        }
       
    
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
        searchController?.searchBar.searchTextField.placeholder = "Search for new location"
        searchController?.searchBar.searchTextField.textColor = UIColor.white
        searchController?.searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        searchController?.searchBar.searchTextField.backgroundColor = UIColor(red: 78/255, green: 88/255, blue: 224/255, alpha: 1.0)
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")!.withTintColor(UIColor.white)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)

    }
    
    var delegate: EditLocationViewControllerDelegate?
    
    
    

}


// Handle the user's selection.
// Handle the user's selection.
extension EditLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
 
    
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    searchController?.isActive = false
    searchController?.dismiss(animated: true, completion: {self.performSegue(withIdentifier: "unwindToPresentingVC", sender: self)})
    delegate?.editLocationViewControllerDidUpdate(didSelect: place, for: date)
    
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


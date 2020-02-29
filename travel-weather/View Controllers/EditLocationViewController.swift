//
//  EditLocationViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 2/28/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

protocol EditLocationViewControllerDelegate {
    func updateLocationForDate(didSelect newLocation: String)
}

class EditLocationViewController: UIViewController{
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        print(self.date!)
        title = dateFormatter.string(from: self.date)
    }
    
    var delegate: EditLocationViewControllerDelegate?
    var date: Date!
    
    

}

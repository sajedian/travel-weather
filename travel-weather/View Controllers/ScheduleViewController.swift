//
//  CalendarViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 2/5/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit
import JTAppleCalendar
import GooglePlaces

class ScheduleViewController: UIViewController{
    
    
    //MARK:- Properties
    var stateController: StateController!

    
    var scheduleListVC: ScheduleListViewController?


    
    //MARK:- Actions
    //action for unwinding from EditLocationVC after location selection
    @IBAction func unwindToScheduleVC(segue: UIStoryboardSegue) {}
    
    
    
    
    
   
    
    //MARK:- Lifecycle
    
    //hide navigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if this line is necessary
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        view.backgroundColor = .charcoalGrayLight
    }
    
    
    //show navigationBar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        view.backgroundColor = .charcoalGrayLight
    }
    
    
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ScheduleListViewController {
            controller.stateController = stateController
            controller.delegate = self
            scheduleListVC = controller
        } else if let controller = segue.destination as? CalendarViewController {
            controller.stateController = stateController
            controller.delegate = self
        }
            
    }
    
    
    
    //MARK:- Helper Functions
    
    private func pushEditLocationVC(dates: [Date]) {
           if let editLocationVC = storyboard?.instantiateViewController(identifier: "editLocationVC") as? EditLocationViewController {
               editLocationVC.dates = dates
               editLocationVC.delegate = self
               navigationController?.pushViewController(editLocationVC, animated: true)
           }
       }


}

extension ScheduleViewController: CalendarViewControllerDelegate {
    func selectedDatesDidChange(to newDates: [Date]) {
        scheduleListVC?.selectedDates = newDates
    }
}

extension ScheduleViewController: ScheduleListViewControllerDelegate {
    func didSelectDates(dates: [Date]) {
        if let editLocationVC = storyboard?.instantiateViewController(identifier: "editLocationVC") as? EditLocationViewController {
            editLocationVC.dates = dates
            editLocationVC.delegate = self
            navigationController?.pushViewController(editLocationVC, animated: true)
        }
    }
}



extension ScheduleViewController: EditLocationViewControllerDelegate {
    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for dates: [Date]?) {
        navigationController?.popViewController(animated: true)
        if let dates = dates {
            stateController.updateOrCreateDays(didSelect: newLocation, for: dates)
        }
        //calendarView.reloadData()
        scheduleListVC?.tableView.reloadData()
    }
}










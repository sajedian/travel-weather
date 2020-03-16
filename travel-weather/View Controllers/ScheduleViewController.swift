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
class ScheduleViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        if let selectedDate = selectedDate {
            let day = stateController.getDayForDate(for: selectedDate)
            cityLabel.text = day.city
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        dateFormatter.dateFormat = "yyyy MM dd"
        let date = dateFormatter.date(from: "2020 02 09")!
        calendarView.scrollToDate(date, animateScroll: false)
        calendarView.backgroundColor = UIColor.darkGray
        selectedDayView.layer.cornerRadius = 15
        resetSelectedDate()
    }
    
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var selectedDayView: UIView!
    @IBOutlet weak var editCityButton: UIButton!
    
    var stateController: StateController!
    var selectedDate: Date?
    
    @IBAction func scrollRight() {
        print("scrolling right")
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let nextMonthDate = Calendar.current.date(byAdding: dateComponents, to: firstVisibleDateInMonth!)!
        print(nextMonthDate)
        calendarView.scrollToDate(nextMonthDate)
    }
    
    @IBAction func scrollLeft() {
        print("scrolling left")
        var dateComponents = DateComponents()
        dateComponents.month = -1
       let previousMonthDate = Calendar.current.date(byAdding: dateComponents, to: firstVisibleDateInMonth!)!
        print(previousMonthDate)
        calendarView.scrollToDate(previousMonthDate)
    }
    
    
    let dateFormatter = DateFormatter()
    var firstVisibleDateInMonth: Date?
    
    //MARK:- Helper Funcitons
    
    func monthAndYearFromVisibleDates(from visibleDates: DateSegmentInfo) -> String {
        dateFormatter.dateFormat = "MMMM yyyy"
        let date = visibleDates.monthDates[0].date
        let monthAndYear = dateFormatter.string(from: date)
        return monthAndYear
    }
    
    func resetSelectedDate() {
        selectedDate = nil
        dateLabel.isHidden = true
        cityLabel.isHidden = true
        editCityButton.isHidden = true
        instructionLabel.isHidden = false
    }
    
    func selectDate(date: Date) {
        selectedDate = date
        let day = stateController.getDayForDate(for: date)
        cityLabel.isHidden = false
        editCityButton.isHidden = false
        dateLabel.isHidden = false
        instructionLabel.isHidden = true
        dateLabel.font = UIFont.systemFont(ofSize: 23)
        cityLabel.text = day.city
        cityLabel.font = UIFont.systemFont(ofSize: 17)
        dateFormatter.dateFormat = "MMMM dd"
        dateLabel.text = dateFormatter.string(from: day.date)
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let controller = segue.destination as! EditLocationViewController
            controller.date = selectedDate!
            controller.delegate = self
    }
    

    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {

       }
    
}

extension ScheduleViewController: EditLocationViewControllerDelegate {
    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for date: Date) {
        stateController.updateLocationForDate(didSelect: newLocation, for: date)
    }
    
    func editLocationViewControllerDidCancel() {
}
}



extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "yyyy MM dd"
        let startDate = dateFormatter.date(from: "2020 02 09")!
        let endDate = dateFormatter.date(from: "2021 02 09")!
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateOutDates: .tillEndOfRow)
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
          guard let cell = view as? DateCell  else { return }
          cell.dateLabel.text = cellState.text
          cell.selectedView.layer.cornerRadius = cell.selectedView.bounds.width/2
          cell.selectedView.backgroundColor = UIColor(red: 224/255, green: 179/255, blue: 0/255, alpha: 1.0)
          handleCellTextColor(cell: cell, cellState: cellState)
          handleCellSelected(cell: cell, cellState: cellState)
       }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.isHidden = false
            print("Cell Selected")
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
       if cellState.dateBelongsTo == .thisMonth {
          cell.dateLabel.textColor = UIColor.white
       } else {
        cell.dateLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
       }
    }
}

extension ScheduleViewController: JTAppleCalendarViewDelegate {

    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
       let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
       self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
       return cell
    }
   func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
       configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        firstVisibleDateInMonth = visibleDates.monthDates.first?.date
        monthLabel.text = monthAndYearFromVisibleDates(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        selectDate(date: date)
        configureCell(view: cell, cellState: cellState)
        
        
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
}

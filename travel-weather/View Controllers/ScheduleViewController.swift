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
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if let selectedDate = selectedDate {
            let city = stateController.getCityForDate(for: selectedDate)
            cityLabel.text = city
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendarProperties()
        configureViewAppearance()
        resetSelectedDate()
        
    }
    
    //MARK:- Helper Functions
    private func configureViewAppearance() {
        calendarView.backgroundColor = UIColor.black
        selectedDayView.layer.cornerRadius = 15
        selectedDayView.backgroundColor = UIColor(red: 42/255, green: 53/255, blue: 170/255, alpha: 1.0)
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        cityLabel.font = UIFont.systemFont(ofSize: 17)
        dateLabel.font = UIFont.systemFont(ofSize: 23)
        resetSelectedDate()
    }
    
    private func configureCalendarProperties() {
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        dateFormatter.dateFormat = "yyyy MM dd"
        let date = DateHelper.currentDateMDYOnly()
        calendarView.scrollToDate(date, animateScroll: false)
    }
    
    private func monthAndYearFromVisibleDates(from visibleDates: DateSegmentInfo) -> String {
        dateFormatter.dateFormat = "MMMM yyyy"
        let date = visibleDates.monthDates[0].date
        let monthAndYear = dateFormatter.string(from: date)
        return monthAndYear
    }
    
    private func resetSelectedDate() {
        selectedDate = nil
        dateLabel.isHidden = true
        cityLabel.isHidden = true
        editCityButton.isHidden = true
        instructionLabel.isHidden = false
    }
    
    private func selectDate(date: Date) {
        selectedDate = date
        cityLabel.text = stateController.getCityForDate(for: date)
        dateLabel.text = DateHelper.monthAndDayFromDate(from: date)
        cityLabel.isHidden = false
        editCityButton.isHidden = false
        dateLabel.isHidden = false
        instructionLabel.isHidden = true
    }
    
    
    
    //MARK:- Properties
    var stateController: StateController!
    var selectedDate: Date?
    let dateFormatter = DateFormatter()
    var firstVisibleDateInMonth: Date?
    
    
    //MARK:- Outlets
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var selectedDayView: UIView!
    @IBOutlet weak var editCityButton: UIButton!
    
    
    //MARK:- Actions
    @IBAction func unwindToScheduleVC(segue: UIStoryboardSegue) {}
    
    @IBAction func scrollRight() {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let nextMonthDate = Calendar.current.date(byAdding: dateComponents, to: firstVisibleDateInMonth!)!
        calendarView.scrollToDate(nextMonthDate)
    }
    @IBAction func scrollLeft() {
        var dateComponents = DateComponents()
        dateComponents.month = -1
       let previousMonthDate = Calendar.current.date(byAdding: dateComponents, to: firstVisibleDateInMonth!)!
        calendarView.scrollToDate(previousMonthDate)
    }
    
    

    

    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let controller = segue.destination as! EditLocationViewController
            controller.date = selectedDate!
            controller.delegate = self
    }

}

extension ScheduleViewController: EditLocationViewControllerDelegate {
    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for date: Date?) {
        self.dismiss(animated: true)
        if let date = date {
            stateController.updateLocationForDate(didSelect: newLocation, for: date)
        }
        
    }
}



extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "yyyy MM dd"
        let startDate = DateHelper.currentDateMDYOnly()
        let endDate = DateHelper.offsetMonth(from: startDate, by: 12)
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateOutDates: .tillEndOfRow)
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
          guard let cell = view as? DateCell  else { return }
          cell.dateLabel.text = cellState.text
          cell.selectedView.layer.cornerRadius = cell.selectedView.bounds.width/2
          cell.selectedView.backgroundColor = UIColor(red: 42/255, green: 53/255, blue: 170/255, alpha: 1.0)
          handleCellTextColor(cell: cell, cellState: cellState)
          handleCellSelected(cell: cell, cellState: cellState)
       }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.isHidden = false

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

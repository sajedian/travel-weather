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
    var days = [Day]()
    
    //month ranges of when calendar will start and end
    var startDate: Date!
    var endDate: Date!
    
    //first visible date on page not including dates from past month
    var firstVisibleDateInMonth: Date?
    
    //dates selected by user
    var firstSelectedDate: Date?
    var twoDatesSelected: Bool {
        return firstSelectedDate != nil && calendarView.selectedDates.count > 1
    }
    
    var scheduleListVC: ScheduleListViewController?
    
    
    //MARK:- Outlets
    @IBOutlet var calendarView: JTAppleCalendarView!
    //stack view for day of the week header
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!

    
    //MARK:- Actions
    //action for unwinding from EditLocationVC after location selection
    @IBAction func unwindToScheduleVC(segue: UIStoryboardSegue) {}
    
    
    @IBAction func scrollRight() {
        guard let firstDate = firstVisibleDateInMonth else {
            return
        }
        let nextMonthDate = firstDate.offsetMonth(by: 1)
        calendarView.scrollToDate(nextMonthDate)
        leftButton.isHidden = false
        //hide right button if at end of calendar
        if nextMonthDate.equalMonthAndYear(otherDate: endDate) {
            rightButton.isHidden = true
        }
    }
    
    @IBAction func scrollLeft() {
        guard let firstDate = firstVisibleDateInMonth else {
            return
        }
        let previousMonthDate = firstDate.offsetMonth(by: -1)
        calendarView.scrollToDate(previousMonthDate)
        rightButton.isHidden = false
        //hide left button if at beginning of calendar
        if previousMonthDate.equalMonthAndYear(otherDate: startDate) {
            leftButton.isHidden = true
        }
    }
    
    
    
   
    
    //MARK:- Lifecycle
    
    //hide navigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendarProperties()
        configureViewAppearance()
        resetSelectedDate()
        
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.reloadData()
    }
    
    
    //show navigationBar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditLocationViewController {
            controller.dates = calendarView.selectedDates
            controller.delegate = self
        } else if let controller = segue.destination as? ScheduleListViewController {
            controller.stateController = stateController
            controller.delegate = self
            scheduleListVC = controller
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
    

    private func configureViewAppearance() {
        resetSelectedDate()
        view.backgroundColor = .charcoalGrayLight
        calendarView.backgroundColor = UIColor.charcoalGrayLight
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    }
    
    private func configureCalendarProperties() {
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        startDate = Date.currentDateMDYOnly()
        endDate = startDate.offsetMonth(by: 12)
        calendarView.scrollToDate(startDate, animateScroll: false)
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        leftButton.isHidden = true
    }
    
    private func resetSelectedDate() {
//        dateRangeLabel.text = "Select dates to view/edit location"
//        indicatorView.isHidden = true
//        tableView.reloadData()
    }
    
    private func onSelectDate() {
        if twoDatesSelected {
//            dateRangeLabel.text = firstSelectedDate?.formatDateRange(to: calendarView.selectedDates.last!)
        } else {
//            dateRangeLabel.text = firstSelectedDate?.monthAndOrdinalDay

        }
//        dateRangeLabel.isHidden = false
//        indicatorView.isHidden = false
//        tableView.reloadData()
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
        calendarView.reloadData()
        scheduleListVC?.tableView.reloadData()
    }
}





extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date.currentDateMDYOnly()
        let endDate = startDate.offsetMonth(by: 12)
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateOutDates: .tillEndOfRow)
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        if cellState.date.timeIntervalSince(Date()) <= -86400 {
            cell.strikeThroughView.isHidden = false
            cell.dotView.isHidden = true
            cell.dateLabel.textColor = UIColor.white.withAlphaComponent(0.5)
            cell.selectedView.isHidden = true
            
        } else {
            cell.strikeThroughView.isHidden = true
            handleCellSelected(cell: cell, cellState: cellState)
            handleCellEvents(cell: cell, cellState: cellState)
            handleCellTextColor(cell: cell, cellState: cellState)
            handleCellStrikeThrough(cell: cell, cellState: cellState)
        }
        
       }
    
    func handleCellStrikeThrough(cell: DateCell, cellState: CellState) {
        if cellState.date.timeIntervalSince(Date()) <= -86400 {
            cell.strikeThroughView.isHidden = false
        } else {
            cell.strikeThroughView.isHidden = true
        }
    }

    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.isHidden = false
            handleCellTextColor(cell: cell, cellState: cellState)

        } else {
            cell.selectedView.isHidden = true
        }

        switch cellState.selectedPosition() {
        case .left:
            cell.selectedViewLeft()
        case .middle:
            cell.selectedViewMiddle()
        case .right:
            cell.selectedViewRight()
        case .full:
            cell.selectedViewFull()
        default: break
        }

        
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.white
       }
       else {
            cell.dateLabel.textColor = UIColor.white.withAlphaComponent(0.5)
       }
       if cellState.isSelected {
          cell.dateLabel.textColor = UIColor.charcoalGray
        }
    }
    
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        let date = cellState.date
        let locationWasSet = stateController.locationWasSet(for: date)
        if locationWasSet {
            cell.dotView.isHidden = false
        } else {
            cell.dotView.isHidden = true
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
        monthLabel.text = firstVisibleDateInMonth?.monthAndYear
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let firstDate = firstSelectedDate {
            calendar.selectDates(from: firstDate, to: date, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            
        } else {
            firstSelectedDate = date
        }
        onSelectDate()
        scheduleListVC?.selectedDates = calendarView.selectedDates
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if date == firstSelectedDate {
            firstSelectedDate = nil
        }
        scheduleListVC?.selectedDates = calendarView.selectedDates
        resetSelectedDate()
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if date.timeIntervalSince(Date()) < -86400 {
            return false
        }
        if twoDatesSelected && cellState.selectionType != .programatic || firstSelectedDate != nil && date < calendarView.selectedDates[0] {
            let shouldSelect = !calendarView.selectedDates.contains(date)
            firstSelectedDate = nil
            calendarView.deselectAllDates()
            return shouldSelect
        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if twoDatesSelected && cellState.selectionType != .programatic {
            firstSelectedDate = nil
            calendarView.deselectAllDates()
            return false
        }
        return true
    }
    
}

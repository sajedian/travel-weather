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
        view.backgroundColor = .charcoalGrayLight
        calendarView.backgroundColor = UIColor.charcoalGrayLight
        selectedDayView.layer.cornerRadius = 15
        selectedDayView.backgroundColor = UIColor.charcoalGray
        selectedDayView.layer.shadowColor = UIColor.black.cgColor
        selectedDayView.layer.shadowOffset = CGSize(width: 0, height: 3)
        selectedDayView.layer.shadowOpacity = 0.7
        selectedDayView.layer.shadowRadius = 3
        
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
        startDate = DateHelper.currentDateMDYOnly()
        endDate = DateHelper.offsetMonth(from: startDate!, by: 12)
        calendarView.scrollToDate(startDate!, animateScroll: false)
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        leftButton.isHidden = true
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
    var startDate: Date?
    var endDate: Date?
    let dateFormatter = DateFormatter()
    var firstVisibleDateInMonth: Date?
    var firstSelectedDate: Date?
    var twoDatesSelected: Bool {
        return firstSelectedDate != nil && calendarView.selectedDates.count > 1
    }
    
    
    //MARK:- Outlets
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var selectedDayView: UIView!
    @IBOutlet weak var editCityButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    
    
    
    
    //MARK:- Actions
    @IBAction func unwindToScheduleVC(segue: UIStoryboardSegue) {}
    
    @IBAction func scrollRight() {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let nextMonthDate = Calendar.current.date(byAdding: dateComponents, to: firstVisibleDateInMonth!)!
        calendarView.scrollToDate(nextMonthDate)
        leftButton.isHidden = false
        if DateHelper.equalMonthAndYear(date1: nextMonthDate, date2: endDate!) {
            rightButton.isHidden = true
        }
        
    }
    @IBAction func scrollLeft() {
        var dateComponents = DateComponents()
        dateComponents.month = -1
       let previousMonthDate = Calendar.current.date(byAdding: dateComponents, to: firstVisibleDateInMonth!)!
        calendarView.scrollToDate(previousMonthDate)
        rightButton.isHidden = false
        if DateHelper.equalMonthAndYear(date1: previousMonthDate, date2: startDate!) {
            leftButton.isHidden = true
        }
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
        navigationController?.popViewController(animated: true)
        if let date = date {
            stateController.updateOrCreateDay(didSelect: newLocation, for: date)
        }
        calendarView.reloadData()
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
        if cellState.date.timeIntervalSince(Date()) <= -86400 {
            cell.strikeThroughView.isHidden = false
            cell.dotView.isHidden = true
            cell.dateLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
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
        
//        var constraints = [NSLayoutConstraint]()
//
//        switch cellState.selectedPosition() {
//        case .left:
//            cell.selectedView.layer.cornerRadius = 15
//            cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
//            constraints.append(cell.selectedView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor))
//        case .middle:
//            cell.selectedView.layer.cornerRadius = 0
//            cell.selectedView.layer.maskedCorners = []
//        case .right:
//            cell.selectedView.layer.cornerRadius = 15
//            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
//        case .full:
//            cell.selectedView.layer.cornerRadius = 15
//            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
//        default: break
//        }
//        
//        NSLayoutConstraint.activate(constraints)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
          cell.dateLabel.textColor = UIColor.white
       }
       else {
        cell.dateLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
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
        monthLabel.text = monthAndYearFromVisibleDates(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let firstDate = firstSelectedDate {
            calendar.selectDates(from: firstDate, to: date, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            firstSelectedDate = date
        }
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if date == firstSelectedDate {
            firstSelectedDate = nil
        }
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

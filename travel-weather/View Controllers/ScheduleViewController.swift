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
    let dateFormatter = DateFormatter()
    var days = [Day]()
    
    //month ranges of when calendar will start and end
    var startDate: Date?
    var endDate: Date?
    
    //first visible date on page not including dates from past month
    var firstVisibleDateInMonth: Date?
    
    //dates selected by user
    var firstSelectedDate: Date?
    var twoDatesSelected: Bool {
        return firstSelectedDate != nil && calendarView.selectedDates.count > 1
    }
    
    
    //MARK:- Outlets
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    //stack view for day of the week header
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    @IBOutlet weak var selectedDayView: UIView!
    //outlets in selectedDayView
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet var indicatorView: UIImageView!
    @IBOutlet var dateRangeView: UIView!
    @IBOutlet var tableView: UITableView!
    
    //MARK:- Actions
    //action for unwinding from EditLocationVC after location selection
    @IBAction func unwindToScheduleVC(segue: UIStoryboardSegue) {}
    
    
    @IBAction func scrollRight() {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let nextMonthDate = Calendar.current.date(byAdding: dateComponents, to: firstVisibleDateInMonth!)!
        calendarView.scrollToDate(nextMonthDate)
        leftButton.isHidden = false
        //hide right button if at end of calendar
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
        //hide left button if at beginning of calendar
        if DateHelper.equalMonthAndYear(date1: previousMonthDate, date2: startDate!) {
            leftButton.isHidden = true
        }
    }
    
    @IBAction func selectedDayViewTapped(_ sender: UITapGestureRecognizer) {
        if firstSelectedDate == nil {
            return
        }
        pushEditLocationVC(dates: calendarView.selectedDates)
        
    }
    
    func pushEditLocationVC(dates: [Date]) {
        if let editLocationVC = storyboard?.instantiateViewController(identifier: "editLocationVC") as? EditLocationViewController {
            editLocationVC.dates = dates
            editLocationVC.delegate = self
            navigationController?.pushViewController(editLocationVC, animated: true)
        }
    }
    
    //MARK:- Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if firstSelectedDate != nil {
            onSelectDate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendarProperties()
        configureViewAppearance()
        resetSelectedDate()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let controller = segue.destination as! EditLocationViewController
            controller.dates = calendarView.selectedDates
            controller.delegate = self
    }
    
    
    
    //MARK:- Helper Functions
    

    private func configureViewAppearance() {
        view.backgroundColor = .charcoalGrayLight
        calendarView.backgroundColor = UIColor.charcoalGrayLight
        selectedDayView.layer.cornerRadius = 15
        selectedDayView.backgroundColor = UIColor.charcoalGray
        selectedDayView.layer.shadowColor = UIColor.black.cgColor
        selectedDayView.layer.shadowOffset = CGSize(width: 0, height: 3)
        selectedDayView.layer.shadowOpacity = 0.4
        selectedDayView.layer.shadowRadius = 3
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        resetSelectedDate()
        tableView.backgroundColor = .charcoalGrayLight
        tableView.layer.cornerRadius = 15
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        dateRangeView.layer.cornerRadius = 15
        dateRangeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
        dateRangeLabel.isHidden = true
        indicatorView.isHidden = true
        tableView.reloadData()
    }
    
    private func onSelectDate() {
        if twoDatesSelected {
            dateRangeLabel.text = DateHelper.formatDateRange(date1: firstSelectedDate!, date2: calendarView.selectedDates.last!)
            
            
        } else {
            dateRangeLabel.text = DateHelper.monthAndDayFromDate(from: firstSelectedDate!)

    }
        dateRangeLabel.isHidden = false
        indicatorView.isHidden = false
        tableView.reloadData()
    }
    
    



}

extension ScheduleViewController: EditLocationViewControllerDelegate {
    func editLocationViewControllerDidUpdate(didSelect newLocation: GMSPlace, for dates: [Date]?) {
        navigationController?.popViewController(animated: true)
        if let dates = dates {
            stateController.updateOrCreateDays(didSelect: newLocation, for: dates)
        }
        calendarView.reloadData()
    }
}

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarView.selectedDates.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        let date = calendarView.selectedDates[indexPath.row]
        let dateDisplay = DateHelper.shortDateFormat(date: date)
        let city = stateController.getCityForDate(for: date)
        cell.textLabel?.text = "\(dateDisplay) - \(city)"
        cell.backgroundColor = .charcoalGrayLight
        cell.textLabel?.textColor = UIColor.white.withAlphaComponent(0.65)
        return cell
    }
    
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = calendarView.selectedDates[indexPath.row]
        pushEditLocationVC(dates: [date])
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
        onSelectDate()

        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if date == firstSelectedDate {
            firstSelectedDate = nil
        }
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

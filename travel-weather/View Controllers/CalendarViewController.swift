//
//  CalendarViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 6/8/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol CalendarViewControllerDelegate: class {
    func selectedDatesDidChange(to newDates: [Date])
    func didDeselectDates()
}

class CalendarViewController: UIViewController {
    
    
    //MARK:- Properties
    
    var stateController: StateController!
    weak var delegate: CalendarViewControllerDelegate?
    
    //month ranges of when calendar will start and end
    private var startDate = Date.currentDateMDYOnly()
    private var endDate = Date.currentDateMDYOnly().offsetMonth(by: 12)
    
    //first visible date on page not including dates from past month
    private var firstVisibleDateInMonth: Date?
    
    //dates selected by user
    private var firstSelectedDate: Date?
    private var twoDatesSelected: Bool {
        return firstSelectedDate != nil && calendarView.selectedDates.count > 1
    }
    
    
    //MARK:- Outlets
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    
    //MARK:- Actions
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //scroll to start and hide left button
        calendarView.scrollToDate(startDate, animateScroll: false)
        leftButton.isHidden = true
        
        //configure scrolling behavior
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        
        //configure selection behavior
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        
        //configureAppearance
        calendarView.backgroundColor = .charcoalGrayLight

    }
    
    //MARK:- Private Methods
    
    private func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        
        //appearance if date is in the past
        if cellState.date.timeIntervalSince(Date()) < Date.secondsInDay * -1 {
            cell.strikeThroughView.isHidden = false
            cell.dotView.isHidden = true
            cell.dateLabel.textColor = UIColor.white.withAlphaComponent(0.5)
            cell.selectedView.isHidden = true
        
        //apperance if date isn't in the past
        } else {
            cell.strikeThroughView.isHidden = true
            handleCellSelected(cell: cell, cellState: cellState)
            handleCellEvents(cell: cell, cellState: cellState)
            handleCellTextColor(cell: cell, cellState: cellState)
        }
        
    }

    
    private func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.isHidden = false
            //handle shape of selected view for ranged selection
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
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    
    private func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
          cell.dateLabel.textColor = UIColor.charcoalGray
        }
        else if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.white
        }
        else {
            cell.dateLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    
    //if user has set location for this date, show event indicator
    private func handleCellEvents(cell: DateCell, cellState: CellState) {
        let date = cellState.date
        let locationWasSet = stateController.locationWasSet(for: date)
        if locationWasSet {
            cell.dotView.isHidden = false
        } else {
            cell.dotView.isHidden = true
        }
    }
    

}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateOutDates: .tillEndOfRow)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {

    //cellForItemAt
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
       let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
       self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
       return cell
    }
    
    //configure cell appearance before displaying
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
       configureCell(view: cell, cellState: cellState)
    }
    
    
    //handle scrolling
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        firstVisibleDateInMonth = visibleDates.monthDates.first?.date
        monthLabel.text = firstVisibleDateInMonth?.monthAndYear
    }
    
    
    
    //selection and deselection
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let firstDate = firstSelectedDate {
            calendar.selectDates(from: firstDate, to: date, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            
        } else {
            firstSelectedDate = date
        }
        delegate?.selectedDatesDidChange(to: calendarView.selectedDates)
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if date == firstSelectedDate {
            delegate?.selectedDatesDidChange(to: calendarView.selectedDates)
            firstSelectedDate = nil
        }
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        //disable selection for dates in the past
        if date.timeIntervalSince(Date()) < Date.secondsInDay * -1 {
            return false
        }
        if twoDatesSelected && cellState.selectionType != .programatic || firstSelectedDate != nil && date < calendarView.selectedDates[0] {
            let shouldSelect = !calendarView.selectedDates.contains(date)
            firstSelectedDate = nil
            calendarView.deselectAllDates()
            delegate?.didDeselectDates()
            return shouldSelect
        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if twoDatesSelected && cellState.selectionType != .programatic {
            firstSelectedDate = nil
            calendarView.deselectAllDates()
            delegate?.didDeselectDates()
            return false
        }
        return true
    }
    
}

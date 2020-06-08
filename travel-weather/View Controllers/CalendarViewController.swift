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
}

class CalendarViewController: UIViewController {
    
    var stateController: StateController!
    weak var delegate: CalendarViewControllerDelegate?
    
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
    
    
    
    //MARK:- Outlets
    @IBOutlet var calendarView: JTAppleCalendarView!
    //stack view for day of the week header
    @IBOutlet var stackView: UIStackView!
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
        calendarView.backgroundColor = UIColor.charcoalGrayLight
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
    

}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date.currentDateMDYOnly()
        let endDate = startDate.offsetMonth(by: 12)
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateOutDates: .tillEndOfRow)
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        if cellState.date.timeIntervalSince(Date()) < Date.secondsInDay * -1 {
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
        if cellState.date.timeIntervalSince(Date()) <= Date.secondsInDay * -1 {
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

extension CalendarViewController: JTAppleCalendarViewDelegate {

    
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
        delegate?.selectedDatesDidChange(to: calendarView.selectedDates)
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if date == firstSelectedDate {
            firstSelectedDate = nil
        }
        delegate?.selectedDatesDidChange(to: calendarView.selectedDates)
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if date.timeIntervalSince(Date()) < Date.secondsInDay * -1 {
            return false
        }
        if twoDatesSelected && cellState.selectionType != .programatic || firstSelectedDate != nil && date < calendarView.selectedDates[0]
        {
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

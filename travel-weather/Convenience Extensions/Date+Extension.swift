//
//  DateHelper.swift
//  travel-weather
//
//  Created by Renee Sajedian on 3/18/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation

extension Date {
    
    //MARK:- Convenience Properties
    static var secondsInDay: Double {
        return 86400
    }
    
    static var secondsInHour: Double {
        return 3600
    }
    
    static func httpDate(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return dateFormatter.date(from: string) ?? nil
    }
    
    //MARK:- Calculations based on current date
    //get current date, ignoring anything but the month, day and year
    static func currentDateMDYOnly() -> Date {
        let calendar = Calendar.current
        let currentDate = Date()
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        let dateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day)
        let modifiedCurrentDate = calendar.date(from: dateComponents)!
        return modifiedCurrentDate
    }
    
    static func dayFromToday(offset: Int) -> Date {
        let today = Date.currentDateMDYOnly()
        return Calendar.current.date(byAdding: .day, value: offset, to: today)!
    }
    
    //MARK:- Calculations based on instance of date
    func offsetMonth(by offset: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: offset, to: self)!
    }
    
    var daysFromCurrentDate: Int {
        let today = Date.currentDateMDYOnly()
        return Int(self.timeIntervalSince(today) / Date.secondsInDay)
    }
    
    var timeIntervalFromCurrentTime: Double {
        let now = Date()
        return self.timeIntervalSince(now)
    }
    
    func equalMonthAndYear(otherDate: Date) -> Bool {
        let calendar = Calendar.current
        let month1 = calendar.component(.month, from: self)
        let month2 = calendar.component(.month, from: otherDate)
        let year1 = calendar.component(.year, from: self)
        let year2 = calendar.component(.year, from: otherDate)
        return month1 == month2 && year1 == year2
    }
    
    
    
    
    //MARK:- Formatting
    func formattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    //i.e. 1st, 2nd, 3rd
    var ordinalDay: String {
        let day = Calendar.current.component(.day, from: self) as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        return numberFormatter.string(from: day)!
    }
    
    //i.e. June 3rd
    var monthAndOrdinalDay: String {
        return formattedDate(format: "MMMM ") + ordinalDay
    }
    
    //i.e. 6/3
    
    var shortMonthAndDay: String {
        return formattedDate(format: "M/d")
    }
    
    var monthAndYear: String {
         return formattedDate(format: "MMMM yyyy")
    }
    
    //returns ISO Date but with no time zone
    var ISODate: String {
        return formattedDate(format: "yyyy-MM-dd'T'HH:mm:ss")
    }

    


    //returns ex: June 1st-3rd if start and end date are in the same month
    //otherwise, returns ex: June 3rd - July 10th
   func formatDateRange(to endDate: Date) -> String {
        let ordinalDay1 = ordinalDay
        let ordinalDay2 = endDate.ordinalDay
        let month1 = formattedDate(format: "MMMM")
        if equalMonthAndYear(otherDate: endDate) {
           return "\(month1) \(ordinalDay1) - \(ordinalDay2)"
       } else {
           let month2 = endDate.formattedDate(format: "MMMM")
           return "\(month1) \(ordinalDay1) - \(month2) \(ordinalDay2)"
       }
           
    }
    
}

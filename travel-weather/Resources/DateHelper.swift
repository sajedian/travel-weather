//
//  DateHelper.swift
//  travel-weather
//
//  Created by Renee Sajedian on 3/18/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation


struct DateHelper {

    
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
        let today = currentDateMDYOnly()
        return Calendar.current.date(byAdding: .day, value: offset, to: today)!
    }
    
    static func offsetMonth(from date: Date, by offset: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: offset, to: date)!
    }
    
    
    static func monthAndDayFromDate(from date: Date) -> String {
        let day = Calendar.current.component(.day, from: date) as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let ordinalDay = numberFormatter.string(from: day)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM "
        return dateFormatter.string(from: date) + ordinalDay
    }
    
    //converts Date to ISO Date string but with no time zone
    static func ISODate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let formattedString = dateFormatter.string(from: date)
        return formattedString
    }
    
    static func httpDate(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return dateFormatter.date(from: string)!
    }
    
    static func timeIntervalToCurrentDate(from date: Date) -> Double {
        let currDate = Date()
        return currDate.timeIntervalSince(date) as Double
    }
    
    static func daysFromCurrentDate(to futureDate: Date) -> Int {
        let currDate = currentDateMDYOnly()
        return Int(futureDate.timeIntervalSince(currDate) / 86400)
    }
    
    static func equalMonthAndYear(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let month1 = calendar.component(.month, from: date1)
        let month2 = calendar.component(.month, from: date2)
        let year1 = calendar.component(.year, from: date1)
        let year2 = calendar.component(.year, from: date2)
        return month1 == month2 && year1 == year2

    }
    
    static func shortDateFormat(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: date)
    }
    
    
}

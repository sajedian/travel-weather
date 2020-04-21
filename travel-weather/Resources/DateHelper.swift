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
//        print("currentDate is \(currentDate)")
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        let dateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day)
        let modifiedCurrentDate = calendar.date(from: dateComponents)!
//        print("modifiedCurrentDate is \(modifiedCurrentDate)")
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter.string(from: date)
    }
    
}
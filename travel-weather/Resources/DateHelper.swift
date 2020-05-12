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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter.string(from: date)
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
    
}

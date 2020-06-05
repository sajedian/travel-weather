//
//  Day+CoreDataProperties.swift
//  travel-weather
//
//  Created by Renee Sajedian on 5/6/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func dayFetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date
    @NSManaged public var weatherDataDate: Date?
    @NSManaged public var locationWasSet: Bool
    @NSManaged public var weatherSummaryValue: String?
    @NSManaged public var location: Location

}

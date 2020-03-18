//
//  Day+CoreDataProperties.swift
//  
//
//  Created by Renee Sajedian on 3/17/20.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date
    @NSManaged public var city: String
    @NSManaged public var weatherSummaryValue: String?
//    @NSManaged public var latitude: Double
//    @NSManaged public var longitude: Double
//    @NSManaged public var highTemp: Int64
//    @NSManaged public var lowTemp: Int64

}

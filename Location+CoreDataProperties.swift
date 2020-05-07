//
//  Location+CoreDataProperties.swift
//  travel-weather
//
//  Created by Renee Sajedian on 5/6/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    @NSManaged public var country: String?
    @NSManaged public var latitude: Double
    @NSManaged public var locality: String
    @NSManaged public var longitude: Double
    @NSManaged public var placeID: String
    @NSManaged public var shortCountry: String?
    @NSManaged public var shortState: String?
    @NSManaged public var state: String?
    @NSManaged public var defaultLocation: Bool

}

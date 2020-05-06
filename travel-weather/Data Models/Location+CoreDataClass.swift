//
//  Location+CoreDataClass.swift
//  
//
//  Created by Renee Sajedian on 5/5/20.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {
    @NSManaged public var locality: String
    @NSManaged public var state: String?
    @NSManaged public var shortState: String?
    @NSManaged public var country: String?
    @NSManaged public var shortCountry: String?
    @NSManaged public var placeID: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
}

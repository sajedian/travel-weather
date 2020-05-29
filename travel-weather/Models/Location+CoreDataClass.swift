//
//  Location+CoreDataClass.swift
//  travel-weather
//
//  Created by Renee Sajedian on 5/6/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//
//

import Foundation
import CoreData
import GooglePlaces

@objc(Location)
public class Location: NSManagedObject {
    convenience init(place: GMSPlace, insertInto context: NSManagedObjectContext) {
        let entity = Location.entity()
        self.init(entity: entity, insertInto: context)
        self.latitude = place.latitude
        self.longitude = place.longitude
        self.locality = place.name!
        self.placeID = place.placeID!
        self.country = place.country
        self.shortCountry = place.shortCountry
        self.state = place.state
        self.shortState = place.shortState
    }
    
    convenience init(location: Location, insertInto context: NSManagedObjectContext) {
        let entity = Location.entity()
        self.init(entity: entity, insertInto: context)
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.locality = location.locality
        self.placeID = location.placeID
        self.country = location.country
        self.shortCountry = location.shortCountry
        self.state = location.state
        self.shortState = location.shortState
    }
    
    @nonobjc public class func locationFetchRequest() -> NSFetchRequest<Location> {
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
     @NSManaged public var colorSetting: ColorSetting?
    
    var display: String {
        if let countryName = country {
            switch countryName {
            case "United States":
               if let shortStateName = shortState {
                    return "\(locality), \(shortStateName), US"
                } else {
                    return "\(locality), US"
                }
            case "Canada", "Mexico", "Australia":
                if let shortStateName = shortState {
                    return "\(locality), \(shortStateName), \(countryName)"
                } else {
                    return "\(locality), \(countryName)"
                }
            default:
                return "\(locality), \(countryName)"
            }
        } else {
            return locality
        }
    }

}

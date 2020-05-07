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
}

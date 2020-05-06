//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Renee Sajedian on 5/5/20.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    

}

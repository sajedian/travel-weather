//
//  ColorSetting+CoreDataClass.swift
//  travel-weather
//
//  Created by Renee Sajedian on 5/7/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ColorSetting)
public class ColorSetting: NSManagedObject {
    @nonobjc public class func colorSettingFetchRequest() -> NSFetchRequest<ColorSetting> {
           return NSFetchRequest<ColorSetting>(entityName: "ColorSetting")
       }

    @NSManaged public var colorHex: String
    @NSManaged public var date: Date
    @NSManaged public var location: Location
    @NSManaged public var placeID: String
}

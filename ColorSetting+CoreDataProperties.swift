//
//  ColorSetting+CoreDataProperties.swift
//  travel-weather
//
//  Created by Renee Sajedian on 5/8/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//
//

import Foundation
import CoreData


extension ColorSetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorSetting> {
        return NSFetchRequest<ColorSetting>(entityName: "ColorSetting")
    }

   

}

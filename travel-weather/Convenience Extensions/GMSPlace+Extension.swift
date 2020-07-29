//
//  GMSPlace+Extension.swift
//  travel-weather
//
//  Created by Renee Sajedian on 6/1/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation
import GooglePlaces

extension GMSPlace {
    var latitude: Double {
        return Double(coordinate.latitude)
    }
    var longitude: Double {
        return Double(coordinate.longitude)
    }
    var state: String? {
        let stateComponent = addressComponents?.first(where: { (component) -> Bool in
            return component.types.contains("administrative_area_level_1")
        })
        return stateComponent?.name
    }

    var shortState: String? {
        let stateComponent = addressComponents?.first(where: { (component) -> Bool in
            return component.types.contains("administrative_area_level_1")
        })
        return stateComponent?.shortName
    }

    var country: String? {
        let countryComponent = addressComponents?.first(where: { (component) -> Bool in
            return component.types.contains("country")
        })
        return countryComponent?.name
    }

    var shortCountry: String? {
        let countryComponent = addressComponents?.first(where: { (component) -> Bool in
            return component.types.contains("country")
        })
        return countryComponent?.shortName
    }
}

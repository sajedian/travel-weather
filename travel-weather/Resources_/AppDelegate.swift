//
//  AppDelegate.swift
//  Travel Weather
//
//  Created by Renee Sajedian on 1/19/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSPlacesClient.provideAPIKey(googleMapsAPIKey)
        
        if UserDefaults.standard.string(forKey: "defaultColor") == nil {
            UserDefaults.standard.set(UIColor.darkYellow.toHex(), forKey: "defaultColor")
        }
        
        if UserDefaults.standard.string(forKey: "temperatureUnits") == nil {
            UserDefaults.standard.set(TemperatureUnits.fahrenheit.rawValue, forKey: "temperatureUnits")
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}


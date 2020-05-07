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
//        if UserDefaults.standard.string(forKey: "city") == nil {
//            UserDefaults.standard.set("Svalbarðsstrandarhreppur", forKey: "city")
//            UserDefaults.standard.set(65.7461132, forKey: "latitude")
//            UserDefaults.standard.set(18.0832997, forKey: "longitude")
//            return true
//        }
        if UserDefaults.standard.string(forKey: "defaultColor") == nil {
            print("set Default Color")
            UserDefaults.standard.set(UIColor.darkYellow.toHex(), forKey: "defaultColor")
        }
        return true
    }
    
    func whereIsMySQLite() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        print(path ?? "Not found")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


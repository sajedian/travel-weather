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

    func customizeAppearance() {
        let barTintColor = UIColor(red: 42/255, green: 53/255, blue: 170/255, alpha: 1.0)
        UISearchBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBarAppearance().shadowColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                           NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2)]
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(googleMapsAPIKey)
        guard let defaultCity = UserDefaults.standard.string(forKey: "city") else {
            UserDefaults.standard.set("Svalbarðsstrandarhreppur", forKey: "city")
            UserDefaults.standard.set(65.7461132, forKey: "latitude")
            UserDefaults.standard.set(18.0832997, forKey: "longitude")
            print("Set default city: " + UserDefaults.standard.string(forKey: "city")!)
            return true
        }
        print("Default city is: \(defaultCity)")
        customizeAppearance()
        return true
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


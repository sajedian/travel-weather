//
//  SceneDelegate.swift
//  Travel Weather
//
//  Created by Renee Sajedian on 1/19/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var stateController: StateController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window?.tintColor = UIColor.charcoalGray
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let viewControllers = tabBarController.viewControllers else {
                return
        }
        //stateController is the central control of the app, any state changes pass through here
        let stateController = StateController()
        
        //gives each view controller in the tab bar access to the single stateController
        let navController = viewControllers[0] as! UINavigationController
        let scheduleViewController = navController.viewControllers.first as! ScheduleViewController
        scheduleViewController.stateController = stateController
       
        let weatherListViewController = viewControllers[1] as! WeatherListViewController
        weatherListViewController.stateController = stateController
        
        let navController2 = viewControllers[2] as! UINavigationController
        let settingsViewController = navController2.viewControllers.first as! SettingsViewController
        settingsViewController.stateController = stateController
        
        customizeAppearance()
        
    }
    
    
    //app-wide customization of search and navigation bars
    func customizeAppearance() {
        let barTintColor = UIColor.charcoalGray
        UISearchBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().backgroundColor = barTintColor
        UINavigationBarAppearance().shadowColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                          NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2)]
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        //starts timer for forecast updates
        stateController?.startUpdateTimer()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        //stops timer for forecast updates
        stateController?.stopUpdateTimer()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        //updates weather data if necessary when app enters foreground
        stateController?.loadAndUpdateData()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


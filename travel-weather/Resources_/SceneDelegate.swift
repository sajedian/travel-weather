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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard scene as? UIWindowScene != nil else { return }

        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let viewControllers = tabBarController.viewControllers else {
            fatalError("Failed to find Tab Bar Controller")
        }
        //stateController is the central control of the app
        //therefore, each VC in the Tab Bar Controller must have access to it
        let stateController = StateController()

        guard let navController1 = viewControllers[0] as? UINavigationController,
            let scheduleViewController = navController1.viewControllers.first as? ScheduleViewController else {
            fatalError("Failed to find ScheduleViewController")
        }

        guard let weatherListViewController = viewControllers[1] as? WeatherListViewController else {
            fatalError("Failed to find WeatherListViewController")
        }

        guard let navController2 = viewControllers[2] as? UINavigationController,
            let settingsViewController = navController2.viewControllers.first as? SettingsViewController else {
            fatalError("Failed to find SettingsViewController")
        }

        //gives each view controller in the tab bar access to the single stateController
        scheduleViewController.stateController = stateController
        weatherListViewController.stateController = stateController
        settingsViewController.stateController = stateController

        customizeAppearance()

    }

    //app-wide customization of search and navigation bars
    func customizeAppearance() {
        let barTintColor = UIColor.charcoalGray
        window?.tintColor = barTintColor
        UISearchBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().backgroundColor = barTintColor
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2)
        ]
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        //starts timer for forecast updates
        stateController?.startUpdateTimer()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        //stops timer for forecast updates
        stateController?.stopUpdateTimer()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        //updates weather data if necessary when app enters foreground
        stateController?.loadAndUpdateData()
    }

}

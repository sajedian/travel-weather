//
//  TabBarController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 2/5/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation
import UIKit


class TabBarController: UITabBarController {

   override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        // For Back button customization, setup the custom image for UINavigationBar inside CustomBackButtonNavController.
        let backButtonBackgroundImage = UIImage(systemName: "arrow.left")
        let barAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [TabBarController.self])
        barAppearance.backIndicatorImage = backButtonBackgroundImage
        barAppearance.backIndicatorImage?.withTintColor(.white)
        barAppearance.backIndicatorTransitionMaskImage = backButtonBackgroundImage
        barAppearance.backItem?.title = ""
        barAppearance.tintColor = .white
        
   }
    
    

}

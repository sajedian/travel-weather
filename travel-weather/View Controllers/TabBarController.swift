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
        //switches to Forecast tab on launch
        self.selectedIndex = 1
        let barAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [UITabBarController.self])
        barAppearance.shadowImage = UIImage()
        
   }
}

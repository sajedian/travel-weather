//
//  ColorPickerViewController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 4/30/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation
import UIKit



class ColorPickerViewController: UIViewController {
    
    //MARK:- Properties
    var stateController: StateController!
    var selectedSetting: ColorSettingType!
    private var colorButtons = [UIButton]()
    
    //MARK:- Actions
    @IBAction func cancel() {
        self.performSegue(withIdentifier: "unwindToColorSettingsVC", sender: self)
    }
       
    @IBAction func updateColor(_ sender: UIButton) {
        //TODO: use list of buttons to get color rather than accessing the background color
        stateController.updateAssociatedColor(color: sender.backgroundColor!, for: selectedSetting)
        performSegue(withIdentifier: "unwindToColorSettingsVC", sender: sender)
    }
   
    //MARK:- Lifecycle
    //adapted from Hacking with Swift (https://www.hackingwithswift.com/read/8/2/building-a-uikit-user-interface-programmatically)
    //MIT License
    
    override func loadView() {
        
        super.loadView()
        view = UIView()
        view.backgroundColor = .systemGray6
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 360)
        ])
        
        createButtons(buttonsView: buttonsView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain, target: self, action: #selector(cancel))
    }
    

   
    private func createButtons(buttonsView: UIView) {
        
        //adapted from Hacking With Swift(https://www.hackingwithswift.com/read/8/2/building-a-uikit-user-interface-programmatically)
        //MIT License
        
        let colors = [UIColor.midnightBlue, UIColor.mutedPink, UIColor.darkPurple, UIColor.mediumGray, UIColor.peach, UIColor.darkYellow, UIColor.darkGreen, UIColor.lightBlue]
        
        let colorButtonWidth = CGFloat(50)
        let buttonsViewWidth = CGFloat(360)
        let numberOfRows = 2
        let numberOfCols = 4
        var buttonConstraints = [NSLayoutConstraint]()
    
        //arranges buttons in a grid, giving each a different color
        for row in 0..<numberOfRows {
            for col in 0..<numberOfCols {
                
                let index = row * numberOfCols + col
                let centerX = buttonsViewWidth * 0.2 * CGFloat(col + 1)
                let centerY = buttonsViewWidth * 0.2 * CGFloat(row + 1)
             
                let button = UIButton(type: .system)
                button.addTarget(self, action: #selector(updateColor), for: .touchUpInside)
                button.backgroundColor = colors[index]
                button.layer.cornerRadius = colorButtonWidth/2
                button.translatesAutoresizingMaskIntoConstraints = false
                
                buttonConstraints.append(contentsOf: [
                    button.heightAnchor.constraint(equalToConstant: colorButtonWidth),
                    button.widthAnchor.constraint(equalToConstant: colorButtonWidth),
                    button.centerXAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: centerX),
                    button.centerYAnchor.constraint(equalTo: buttonsView.topAnchor, constant: centerY)
                ])
                
                buttonsView.addSubview(button)
                colorButtons.append(button)
            }
        }
        NSLayoutConstraint.activate(buttonConstraints)
    }
    
    
  
}

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
    
    var colorButtons = [UIButton]()
    var stateController: StateController!
    var selectedSetting: ColorSettingType!
    
    //MARK:- Actions
       @IBAction func cancel() {
           self.performSegue(withIdentifier: "unwindToColorSettingsVC", sender: self)
       }
       
       @IBAction func updateColor(_ sender: UIButton) {
           stateController.updateAssociatedColor(color: sender.backgroundColor!, for: selectedSetting)
           performSegue(withIdentifier: "unwindToColorSettingsVC", sender: sender)
       }
   
    
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(cancel))
    }
    
   
    func createButtons(buttonsView: UIView) {
        var colors = [UIColor.midnightBlue, UIColor.peach, UIColor.mutedPink, UIColor.darkPurple, UIColor.mediumGray, UIColor.darkYellow, UIColor.darkGreen, UIColor.lightBlue]
        colors = [UIColor.midnightBlue, UIColor.mutedPink, UIColor.darkPurple, UIColor.mediumGray, UIColor.peach, UIColor.darkYellow, UIColor.darkGreen, UIColor.lightBlue]
        
        let colorButtonWidth = CGFloat(50)
        var buttonConstraints = [NSLayoutConstraint]()
    
        //arranges buttons in a 4x2 grid, giving each a different color
        for row in 0..<2 {
            for col in 0..<4 {
                let index = row * 4 + col
                print(index)
                let button = UIButton(type: .system)
                button.addTarget(self, action: #selector(updateColor), for: .touchUpInside)
                let centerX = 360 * 0.2 * CGFloat(col + 1)
                let centerY = 360 * 0.2 * CGFloat(row + 1)
                button.translatesAutoresizingMaskIntoConstraints = false
                buttonConstraints.append(contentsOf: [
                    button.heightAnchor.constraint(equalToConstant: colorButtonWidth),
                    button.widthAnchor.constraint(equalToConstant: colorButtonWidth),
                    button.centerXAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: centerX),
                    button.centerYAnchor.constraint(equalTo: buttonsView.topAnchor, constant: centerY)
                ])
                
                
                button.backgroundColor = colors[index]
                button.layer.cornerRadius = 25
                buttonsView.addSubview(button)

                colorButtons.append(button)
            }
        }
        NSLayoutConstraint.activate(buttonConstraints)
    }
    
    
  
}

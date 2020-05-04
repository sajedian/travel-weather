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
    
    var colorButtons = [UIButton]()
    var stateController: StateController!
    var selectedSetting: ColorSetting!
   
    override func loadView() {
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
        let colors = [UIColor.mutedPink, UIColor.darkRed, UIColor.charcoalGray, UIColor.darkGreen, UIColor.midnightBlue, UIColor.darkYellow, UIColor.darkOrange, UIColor.lightBlue, UIColor.darkPurple]
        
        
        let colorButtonWidth = CGFloat(50)
        var buttonConstraints = [NSLayoutConstraint]()
        for row in 0..<2 {
            for col in 0..<4 {
                let index = row * 3 + col
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
                
//              let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                
                button.layer.cornerRadius = 25
                buttonsView.addSubview(button)

                colorButtons.append(button)
            }
        }
        NSLayoutConstraint.activate(buttonConstraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(cancel))
        
        
    }
    
    //MARK:- Actions
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateColor(_ sender: UIButton) {
        stateController.updateAssociatedColor(color: sender.backgroundColor!, for: selectedSetting)
        performSegue(withIdentifier: "unwindToColorSettingsVC", sender: sender)
    }
    
  
}


extension UIImage {

  func scaled(with scale: CGFloat) -> UIImage? {
      // size has to be integer, otherwise it could get white lines
      let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
      UIGraphicsBeginImageContext(size)
      draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image
  }

}

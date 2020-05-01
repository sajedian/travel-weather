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
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10)
        ])
        let colors = [UIColor.mutedPink, UIColor.darkRed, UIColor.charcoalGray, UIColor.darkGreen, UIColor.midnightBlue, UIColor.darkYellow, UIColor.darkOrange, UIColor.lightBlue, UIColor.darkPurple]
        
        // set some values for the width and height of each button
        let width = 110
        let height = 75

        for row in 0..<3 {
            for col in 0..<3 {
                let index = row * 3 + col
                // create a new button and give it a big font size
                let button = UIButton(type: .system)
                let circleImage = UIImage(systemName: "icloud.circle.fill")
                let scaledImage = circleImage?.scaled(with: 3)
                
                button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                button.setImage(scaledImage, for: .normal)
                button.tintColor = colors[index]
                
                
                
                // give the button some temporary text so we can see it on-screen

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                button.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(button)

                // and also to our letterButtons array
                colorButtons.append(button)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(cancel))
        
        
    }
    
    //MARK:- Actions
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
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

//
//  ColorPallete.swift
//  travel-weather
//
//  Created by Renee Sajedian on 5/1/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var darkRed: UIColor { return UIColor(hex: "#461220ff")! }
    static var mutedPink: UIColor { return UIColor(hex: "#e08283ff")! }
    static var peach: UIColor { return UIColor(hex: "#ec644bff")! }
    static var darkYellow: UIColor { return UIColor(hex: "#D1A305ff")! }
    static var darkGreen: UIColor { return UIColor(hex: "#68A187ff")! }
    static var charcoalGray: UIColor { return UIColor(hex: "#2F4452ff")! }
    static var charcoalGrayLight: UIColor { return UIColor(hex: "#425763ff")!}
    static var charcoalGrayDark: UIColor { return UIColor(hex: "#263746ff")!}
    static var midnightBlue: UIColor { return UIColor(hex: "#d64541ff")! }
    static var lightBlue: UIColor { return UIColor(hex: "#5c97bfff")! }
    static var darkPurple: UIColor { return UIColor(hex: "#947cb0ff")! }
    static var mediumGray: UIColor { return UIColor(hex: "#6c7a89ff")!}
}
  //

// adapted from Hacking with Swift
// https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
// MIT License

extension UIColor {
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
    
    
    func toHex() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgba: Int = (Int)(red*255)<<24 | (Int)(green*255)<<16 | (Int)(blue*255)<<8 | (Int)(alpha*255)
        return String(format: "#%08x", rgba)
    }
}

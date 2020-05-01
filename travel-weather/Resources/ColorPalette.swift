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
    static var mutedPink: UIColor { return UIColor(hex: "#CC4843ff")! }
    static var darkOrange: UIColor { return UIColor(hex: "#B73F21ff")! }
    static var darkYellow: UIColor { return UIColor(hex: "#D1A305ff")! }
    static var darkGreen: UIColor { return UIColor(hex: "#1E3538ff")! }
    static var charcoalGray: UIColor { return UIColor(hex: "#2F4452ff")! }
    static var midnightBlue: UIColor { return UIColor(hex: "#07455Aff")! }
    static var lightBlue: UIColor { return UIColor(hex: "#2A5859ff")! }
    static var darkPurple: UIColor { return UIColor(hex: "#52297cff")! }

//    let mutedPink = UIColor(hex: )
//    let darkOrange = UIColor(hex: )
//    let darkYellow = UIColor(hex: )
//    let darkGreen = UIColor(hex: )
//    let charcoalGray = UIColor(hex: "2F4452")
//    let midnightBlue = UIColor(hex: )
//    let lightBlue = UIColor(hex: )
//    let darkPurple = UIColor(hex: )
//
//    public var colorArray: [UIColor] {
//        return [darkRed, mutedPink, darkOrange, darkYellow, darkGreen, charcoalGray, midnightBlue, lightBlue, darkPurple]
//    }
}


// from Hacking with Swift
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
}

//
//  UIColor+Extensions.swift
//  Prototype
//
//  Created by Miravzal Sultonov on 1/2/25.
//

import UIKit

extension UIColor {
    public convenience init(hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: 1
        )
    }

    public convenience init?(hex: String) {
        guard hex.count > 6 else { return nil }

        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        guard hex.hasPrefix("#"),
              scanner.scanHexInt64(&hexNumber)
        else { return nil }

        switch hexColor.count {
        case 6:
            let red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            let green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            let blue = CGFloat(hexNumber & 0x0000ff) / 255

            self.init(red: red, green: green, blue: blue, alpha: 1)
        case 8:
            let red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            let green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            let blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            let alpha = CGFloat(hexNumber & 0x000000ff) / 255

            self.init(red: red, green: green, blue: blue, alpha: alpha)
        default:
            return nil
        }
    }
}

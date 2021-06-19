//
//  ColorExtension.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import UIKit

extension UIColor {
    
    static func fromHexCode(hex:String, alpha: CGFloat = 1.0) -> UIColor {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let color = UIColor.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                                 green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                                 blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                                 alpha: alpha)
        return color
    }
}

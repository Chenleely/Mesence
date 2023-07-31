//
//  NSColorExtension.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation
import Cocoa

extension NSColor {
    class func hexToRGB(hex: String) -> (red: CGFloat, green: CGFloat, blue: CGFloat)? {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            return nil
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return (red, green, blue)
    }
    
    convenience init(hexString: String) {
        if let rgb = NSColor.hexToRGB(hex: hexString) {
            self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1)
        } else {
            self.init()
        }
    }
}

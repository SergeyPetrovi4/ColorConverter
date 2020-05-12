//
//  ConverterManager.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 01/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation

class ConverterManager {
    
    static let shared = ConverterManager()
    private init() {}
    
    var descriptions = [ColorDescription]()
    
    func convertHexToRgb(from hex: String) {
        
        func cgFloatValue(from value: CGFloat) -> CGFloat? {
            
            guard let number = NumberFormatter().number(from: String(format: "%.2f", value)) else {
                return nil
            }
            
            return CGFloat(number.doubleValue)
        }
        
        self.descriptions.removeAll()
        
        var r, g, b, a: CGFloat
        var start: String.Index = hex.index(hex.startIndex, offsetBy: 0)

        if hex.hasPrefix("#") {
            start = hex.index(hex.startIndex, offsetBy: 1)
        }
                    
        var hexColor = String(hex[start...])
        
        if hexColor.count <= 8 {
            hexColor += "ff" // Add alpha by default
        }
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
            
            if let valueR = cgFloatValue(from: r),
                let valueG = cgFloatValue(from: g),
                let valueB = cgFloatValue(from: b),
                let valueA = cgFloatValue(from: a) {
                
                r = CGFloat(valueR)
                g = CGFloat(valueG)
                b = CGFloat(valueB)
                a = CGFloat(valueA)
            }
            
            self.descriptions.append(contentsOf: [
                    ColorDescription(icon: .swiftui, value: "Color(red: \(r), green: \(g), blue: \(b), alpha: \(a))"),
                    ColorDescription(icon: .ios, value: "UIColor(red: \(r), green: \(g), blue: \(b), alpha: \(a))"),
                    ColorDescription(icon: .mac, value: "NSColor(red: \(r), green: \(g), blue: \(b), alpha: \(a))"),
                    ColorDescription(icon: .xamarin, value: "new UIColor(red: \(r)f, green: \(g)f, blue: \(b)f, alpha: \(a)f)"),
                    ColorDescription(icon: .java, value: "Color.rgb(\(Int(r * 255)), \(Int(g * 255)), \(Int(b * 255)))"),
                    ColorDescription(icon: .csharp, value: "Color.FromArgb(\(Int(r * 255)), \(Int(g * 255)), \(Int(b * 255)), \(Int(a * 255)))"),
                    ColorDescription(icon: .flutter, value: "Color.FromARGB(\(Int(r * 255)), \(Int(g * 255)), \(Int(b * 255)), \(Int(a * 255)))")
                ]
            )
        }
    }
}

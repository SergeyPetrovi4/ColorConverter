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
        
        let value = self.hexRgb(hex: hex)
        self.descriptions.removeAll()
        
        self.descriptions.append(contentsOf: [
            ColorDescription(icon: .swiftui, value: "Color(red: \(value.r), green: \(value.g), blue: \(value.b), alpha: \(value.a))"),
            ColorDescription(icon: .ios, value: "UIColor(red: \(value.r), green: \(value.g), blue: \(value.b), alpha: \(value.a))"),
            ColorDescription(icon: .mac, value: "NSColor(red: \(value.r), green: \(value.g), blue: \(value.b), alpha: \(value.a))"),
            ColorDescription(icon: .xamarin, value: "new UIColor(red: \(value.r)f, green: \(value.g)f, blue: \(value.b)f, alpha: \(value.a)f)"),
            ColorDescription(icon: .java, value: "Color.rgb(\(Int(value.r * 255)), \(Int(value.g * 255)), \(Int(value.b * 255)))"),
            ColorDescription(icon: .csharp, value: "Color.FromArgb(\(Int(value.r * 255)), \(Int(value.g * 255)), \(Int(value.b * 255)), \(Int(value.a * 255)))"),
            ColorDescription(icon: .flutter, value: "Color.FromARGB(\(Int(value.r * 255)), \(Int(value.g * 255)), \(Int(value.b * 255)), \(Int(value.a * 255)))")
            ]
        )
    }
    
    func hexRgb(hex: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        
        func cgFloatValue(from value: CGFloat) -> CGFloat? {
            
            guard let number = NumberFormatter().number(from: String(format: "%.2f", value)) else {
                return nil
            }
            
            return CGFloat(number.doubleValue)
        }
                
        var r = CGFloat(0), g = CGFloat(0), b = CGFloat(0), a = CGFloat(0)
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
                        
        }
        
        return (r, g, b, a)
    }
}

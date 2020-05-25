//
//  ColorDescription.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 01/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation

enum OSType: String {
    case ios = "Swift Cocoa Touch"
    case mac = "Swift Cocoa"
    case xamarin = "Xamarin"
    case swiftui = "SwiftUI"
    case java = "Java"
    case csharp = "C Sharp"
    case flutter = "Flutter"
}

struct ColorDescription {
    
    var title: OSType
    var value: String
}

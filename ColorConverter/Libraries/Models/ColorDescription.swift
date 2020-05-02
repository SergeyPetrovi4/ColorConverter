//
//  ColorDescription.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 01/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation

enum OSType: String {
    case ios
    case mac
    case xamarin
    case swiftui
}

struct ColorDescription {
    
    var icon: OSType
    var value: String
}

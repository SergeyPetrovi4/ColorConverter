//
//  String.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 23/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation

extension String {
    
    var isHexColor: Bool {
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^([A-Fa-f0-9]{6}|[#A-Fa-f0-9]{7})$")        
        return predicate.evaluate(with: self)
    }
    
    var hex: String {
        
        let components = self.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",")
        
        if components.isEmpty {
            return ""
        }
        
        return components.map { String(format: "%02hhx", $0) }.joined()
    }
}

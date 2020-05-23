//
//  FavoritesManager.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 05/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import Foundation
import CoreData

class ColorHistoryManager {
    
    static let shared = ColorHistoryManager()
    private let key = "com.colortocode.colorhistory"
    private init() {}
    
    // MARK: - Retrive favorites
    
    var colors: [String] {
        return UserDefaults.standard.array(forKey: self.key) as? [String] ?? [String]()
    }
        
    // MARK: - Save favorite
    
    func append(color hex: String) {
        
        var colors = self.colors
        
        if colors.count >= 15 {
            colors.removeLast()
        }
        
        colors.insert(hex, at: 0)
        self.update(elements: colors)
    }
    
    func remove(colors hex: String) {
        
        if !self.colors.isEmpty {
            
            let elements = self.colors.filter({ $0 != hex })
            self.update(elements: elements)
            return
        }
        
        print("ColorToCode: Nothing to remove from db!")
    }
    
    // MARK: - Private
    
    private func update(elements: [String]) {
        UserDefaults.standard.set(elements, forKey: self.key)
        UserDefaults.standard.synchronize()
    }
}

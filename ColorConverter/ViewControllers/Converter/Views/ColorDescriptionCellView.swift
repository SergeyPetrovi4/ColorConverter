//
//  ColorDescriptionCellView.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 01/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Cocoa

class ColorDescriptionCellView: NSTableCellView {
        
    @IBOutlet weak var titleTextView: NSTextField!
    
    func configure(with description: ColorDescription) {
        
        self.textField?.stringValue = description.value
        self.textField?.font = NSFont.systemFont(ofSize: 14.0)
        self.titleTextView.stringValue = description.title.rawValue
    }
}

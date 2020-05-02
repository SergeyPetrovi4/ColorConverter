//
//  ColorDescriptionCellView.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 01/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Cocoa

class ColorDescriptionCellView: NSTableCellView {
    
    @IBOutlet weak var osImageView: NSImageView!
    
    func configure(with description: ColorDescription) {
        self.textField?.stringValue = description.value
        self.textField?.font = NSFont.systemFont(ofSize: 13.0)
        self.osImageView.image = NSImage(named: description.icon.rawValue)
    }
}

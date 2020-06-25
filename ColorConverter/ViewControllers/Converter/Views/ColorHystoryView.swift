//
//  ColorHystoryView.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 23/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation
import Cocoa

class ColorHistoryView: NSView {
    
    typealias SelectHistoryItemHandler = ((Int) -> Void)
    
    private var index: Int = 0
    private var completion: SelectHistoryItemHandler?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 20.0),
            self.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        
        self.layer?.cornerRadius = 3.0
        self.layer?.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
    }
    
    // MARK: - Configure
    
    func set(color: NSColor, atIndex index: Int, completion: SelectHistoryItemHandler?) {
        
        self.layer?.backgroundColor = color.cgColor
        self.index = index
        self.completion = completion
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        self.completion?(self.index)
    }
}

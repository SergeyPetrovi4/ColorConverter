//
//  DeleteBadgeView.swift
//  Color2Code
//
//  Created by Sergey Krasiuk on 25/06/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation
import Cocoa
import QuartzCore

class DeleteBadgeView: NSView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        
        let shadowLayer = NSShadow()
        shadowLayer.shadowColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        shadowLayer.shadowOffset = CGSize(width: 0, height: -1.0)
        shadowLayer.shadowBlurRadius = 2.0
        self.shadow = shadowLayer
        
        self.layer?.backgroundColor = NSColor(red: 0.93, green: 0.37, blue: 0.33, alpha: 1.0).cgColor
        
        let crossImageView = NSImageView()
        crossImageView.translatesAutoresizingMaskIntoConstraints = false
        crossImageView.image = NSImage(named: "cross")
        crossImageView.imageAlignment = .alignCenter
        self.addSubview(crossImageView)
        
        NSLayoutConstraint.activate([
            crossImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            crossImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            crossImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            crossImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
    }
}

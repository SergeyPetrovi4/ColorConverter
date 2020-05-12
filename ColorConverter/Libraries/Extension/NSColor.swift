//
//  NSColor.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 12/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics

extension NSColor {
    
    var colorByLocation: NSColor? {
        
        var displayID = CGDirectDisplayID()
        var count: UInt32 = 0
        guard CGGetDisplaysWithPoint(NSPointToCGPoint(NSEvent.mouseLocation), 1, &displayID, &count) != CGError.success else {
            return nil
        }
        
        guard let imageRef = CGDisplayCreateImage(displayID, rect: CGRect(origin: NSEvent.mouseLocation, size: CGSize(width: 1, height: 1))) else {
            return nil
        }
        
        let bitmap = NSBitmapImageRep(cgImage: imageRef)
        
        print(bitmap.colorAt(x: 0, y: 0)!)
        return bitmap.colorAt(x: 0, y: 0)
    }
}

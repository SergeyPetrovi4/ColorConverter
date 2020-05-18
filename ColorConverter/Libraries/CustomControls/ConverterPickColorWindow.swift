//
//  ConverterPickColorWindow.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 17/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

typealias CompletionHandler = ((String?) -> Void)

class ConverterPickColorWindow: NSWindow {

    private var pixelZoom: CGFloat = 7
    private var completion: CompletionHandler?

    var image: CGImage?

    override var canBecomeKey: Bool {
        return true
    }

    override var acceptsFirstResponder: Bool {
        return true
    }
    
    public init(contentRect: NSRect,
                styleMask style: NSWindow.StyleMask,
                backing backingStoreType: NSWindow.BackingStoreType,
                defer flag: Bool,
                completion: CompletionHandler?) {
        
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.level = .popUpMenu
        self.ignoresMouseEvents = false
        self.hasShadow = false

        let captureView = ConverterPickColorView(frame: self.frame)
        self.contentView = captureView

        self.drawContext()
        NSCursor.hide()
        
        self.completion = completion
    }
    
    private func drawContext() {
        
        let point = NSEvent.mouseLocation
        var count = UInt32(0)
        var displayID = CGDirectDisplayID(0)

        if CGGetDisplaysWithPoint(point, 1, &displayID, &count) != CGError.success {
            return
        }

        let captureSize = CGFloat(self.frame.size.width / self.pixelZoom)
        let screenFrame = NSScreen.main!.frame
        let x = floor(point.x) - floor(captureSize / 2)
        let y = screenFrame.size.height - floor(point.y) - floor(captureSize / 2)
        let windowID = self.windowNumber >= 0 ? CGWindowID(self.windowNumber) : 0

        guard let image = CGWindowListCreateImage(CGRect(x: x, y: y, width: captureSize, height: captureSize), .optionOnScreenBelowWindow, windowID, .nominalResolution) else {
            return
        }
        
        self.image = image

        let origin = NSPoint(
            x: floor(point.x) - floor(self.frame.size.width / 2),
            y: floor(point.y) - floor(self.frame.size.height / 2)
        )
        self.setFrameOrigin(origin)

        let captureView = self.contentView as! ConverterPickColorView
        captureView.image = self.image
        captureView.needsDisplay = true
    }

    open override func mouseMoved(with event: NSEvent) {
        
        self.drawContext()
        super.mouseMoved(with: event)
    }

    override func mouseDown(with event: NSEvent) {
        
        let point = NSEvent.mouseLocation
        let f = self.frame
        
        if NSPointInRect(point, f) {
            
            if let image = self.image, let hexColor = image.hexFromRGB() {
                self.completion?(hexColor)
            }
            
            self.orderOut(self)
        }
    }

    open override func scrollWheel(with event: NSEvent) {
        if event.deltaY > 0.01 {
            self.pixelZoom += 1
            
        } else if event.deltaY < -0.01 {
            self.pixelZoom -= 1
        }
        
        self.pixelZoom = self.pixelZoom.clamped(to: 2 ... 24)
        (self.contentView as? ConverterPickColorView)?.pixelZoom = self.pixelZoom

        self.mouseMoved(with: event)
        super.scrollWheel(with: event)
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == kVK_Escape {

            self.orderOut(self)
        }
    }
}

private extension ExpressibleByIntegerLiteral where Self: Comparable {
    
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}

private extension CGImage {
    
    func colorRGB() -> NSColor? {
        
        let bitmapImageRep = NSBitmapImageRep(cgImage: self)
        let centerX = Int(bitmapImageRep.size.width) / 2
        let centerY = Int(bitmapImageRep.size.height) / 2

        return bitmapImageRep.colorAt(x: centerX, y: centerY)
    }
    
    func hexFromRGB() -> String? {
        
        guard let components = colorRGB()?.cgColor.components else {
            return nil
        }
        
        let r = CGFloat(components[0])
        let g = CGFloat(components[1])
        let b = CGFloat(components[2])

        return String.init(format: "#%02lX%02lX%02lX", Int(Float(r * 255)), Int(Float(g * 255)), Int(Float(b * 255)))
    }
}

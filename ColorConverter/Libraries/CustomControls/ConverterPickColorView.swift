//
//  ConverterPickColorView.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 17/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Cocoa

class ConverterPickColorView: NSView {

    var pixelZoom: CGFloat = 7
    var image: CGImage?

    private var currentContext: CGContext? {
        
        guard let current = NSGraphicsContext.current else {
            return nil
        }
        
        if #available(OSX 10.10, *) {
            return current.cgContext
            
        } else {
            return Unmanaged<CGContext>.fromOpaque(current.graphicsPort).takeUnretainedValue()
        }
    }

    override func draw(_: NSRect) {
        
        guard let context = self.currentContext else {
            fatalError()
        }

        // Clear the drawing rect.
        context.clear(self.bounds)

        let rect = self.bounds

        let width: CGFloat = rect.width
        let height: CGFloat = rect.height

        // mask
        let path = CGMutablePath()
        path.addEllipse(in: rect)
        context.addPath(path)
        context.clip()

        if let image = image {
            // draw image
            context.setRenderingIntent(.relativeColorimetric)
            context.interpolationQuality = .none
            context.draw(image, in: rect)
        }

        // draw the aperture
        let apertureSize: CGFloat = self.pixelZoom
        let x: CGFloat = (width / 2.0) - (apertureSize / 2.0)
        let y: CGFloat = (height / 2.0) - (apertureSize / 2.0)

        let apertureRect = CGRect(x: x, y: y, width: apertureSize, height: apertureSize)
        context.setStrokeColor(NSColor.textColor.cgColor)
        context.setShouldAntialias(false)
        context.stroke(apertureRect)
        context.setStrokeColor(NSColor.textBackgroundColor.cgColor)
        context.stroke(apertureRect.insetBy(dx: -1.0, dy: -1.0))

        // stroke outer circle
        context.setShouldAntialias(true)
        context.setLineWidth(1.0)
        context.setStrokeColor(NSColor.textColor.cgColor)
        context.strokeEllipse(in: rect.insetBy(dx: 1.0, dy: 1.0))
        context.setStrokeColor(NSColor.textBackgroundColor.cgColor)
        context.strokeEllipse(in: rect)
    }
}

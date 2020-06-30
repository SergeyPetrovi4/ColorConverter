//
//  ColorHystoryView.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 23/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation
import Cocoa

protocol ColorHistoryViewDelegate {
    func longPressAction()
    func selectColorAction()
}

class ColorHistoryView: NSView {    
    
    var delegate: ColorHistoryViewDelegate?
        
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        
        self.layer?.cornerRadius = 3.0
        self.layer?.masksToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let longPressGestureRecognizer = NSPressGestureRecognizer(target: self, action: #selector(showRemoveButton(gesture:)))
        longPressGestureRecognizer.minimumPressDuration = 0.45
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    init(parent: NSView, rect: NSRect) {
        super.init(frame: rect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
    }
    
    // MARK: - Configure
    
    func set(color: NSColor) {
        self.layer?.backgroundColor = color.cgColor
    }
    
    @objc func showRemoveButton(gesture: NSGestureRecognizer) {
                        
        if gesture.state != .began {
            return
        }
        
        self.delegate?.longPressAction()
    }
        
    // MARK: - Actions
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        self.delegate?.selectColorAction()
    }
    
    // MARK: - Deinit
    
    deinit {
        debugPrint("Deinit: \(self)")
    }
}

extension ColorHistoryView {
    
    func shake() {
        
        self.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5))
        
        let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(0.15, 0, 0, 1)),NSValue(caTransform3D: CATransform3DMakeRotation(-0.15, 0, 0, 1))]
        transformAnim.autoreverses = true
        transformAnim.duration  = 0.2
        transformAnim.repeatCount = Float.infinity
        self.layer!.add(transformAnim, forKey: "rotation")
    }
    
    func dropAnimation() {
        self.layer?.removeAllAnimations()
    }
}

extension NSView {
    
    func setAnchorPoint(anchorPoint:CGPoint) {
        if let layer = self.layer {
            var newPoint = NSPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
            var oldPoint = NSPoint(x: self.bounds.size.width * layer.anchorPoint.x, y: self.bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(layer.affineTransform())
        oldPoint = oldPoint.applying(layer.affineTransform())

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y


        layer.anchorPoint = anchorPoint
        layer.position = position
    }
}
}

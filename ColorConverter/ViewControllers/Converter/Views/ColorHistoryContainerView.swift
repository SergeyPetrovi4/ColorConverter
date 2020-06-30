//
//  ColorHistoryContainerView.swift
//  Color2Code
//
//  Created by Sergey Krasiuk on 26/06/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation
import Cocoa

class ColorHistoryContainerView: NSView {
    
    enum GestureType {
        case mouseUp
        case longPress
    }
    
    enum ActionType {
        case select
        case remove
        case clean
    }
    
    typealias SelectHistoryItemHandler = ((Int, ActionType) -> Void)
    
    var colorHistory: ColorHistoryView?
    
    private var index: Int = 0
    private var deleteBadgeView: DeleteBadgeView?
    private var gestureType = GestureType.mouseUp
    private var completion: SelectHistoryItemHandler?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 27.0),
            self.heightAnchor.constraint(equalToConstant: 27.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
    }
    
    // MARK: - Configure
    
    func set(color: NSColor, atIndex index: Int, completion: SelectHistoryItemHandler?) {
        
        guard let view = self.colorHistory else {
            return
        }
        
        view.layer?.backgroundColor = color.cgColor
        self.index = index
        self.completion = completion
    }
    
    func layoutChildIfNeeded() {
        
        self.colorHistory?.delegate = self
        guard let node = self.colorHistory else {
            return
        }
        
        self.addSubview(node)
        
        NSLayoutConstraint.activate([
            node.widthAnchor.constraint(equalToConstant: 20.0),
            node.heightAnchor.constraint(equalToConstant: 20.0),
            node.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            node.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    func addDeleteButton() {
        
        self.deleteBadgeView = DeleteBadgeView(rect: CGRect(x: 9, y: 9, width: 17, height: 17)) {
            self.completion?(self.index, .remove)
        }
        
        guard let badge = self.deleteBadgeView else {
            return
        }
        
        badge.alphaValue = 0
        badge.layer?.cornerRadius = badge.frame.width / 2.0
        self.addSubview(badge)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.3
            badge.animator().alphaValue = 1
        })
        
        self.gestureType = .mouseUp
    }
    
    func removeDeleteButton() {
        self.deleteBadgeView?.removeFromSuperview()
        self.deleteBadgeView = nil
    }
    
    func update(index: Int) {
        self.index = index
    }
    
    deinit {
        debugPrint("Deinit: \(self)")
    }
}

extension ColorHistoryContainerView: ColorHistoryViewDelegate {
    
    func selectColorAction() {
        
        if self.gestureType == .longPress {
            return
        }
        
        self.completion?(self.index, .select)
    }
    
    func longPressAction() {
        
        if self.deleteBadgeView != nil {
            return
        }
        
        self.completion?(self.index, .clean)
        
        self.addDeleteButton()
        self.colorHistory?.shake()
    }
}

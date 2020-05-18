//
//  ConverterColorPicker.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 17/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Cocoa

typealias PickedColorHandler = ((String?) -> Void)

public class ConverterColorPicker: NSObject {
    
    static let shared = ConverterColorPicker()
    private var screenPickerWindow: ConverterPickColorWindow?
    private var completion: PickedColorHandler?
    
    private override init() {}
    
    func show(completion: @escaping PickedColorHandler) {
        self.completion = completion
        self.pickColor()
    }
}

private extension ConverterColorPicker {

    private func pickColor() {
        self.drop()
        self.run()
    }

    func run() {
        
        self.screenPickerWindow = ConverterPickColorWindow(contentRect: NSRect(x: NSEvent.mouseLocation.x, y: NSEvent.mouseLocation.y, width: 120, height: 120),
                                                           styleMask: .borderless,
                                                           backing: .buffered,
                                                           defer: true,
                                                           completion: { (hex) in
            
            if let hexColor = hex { self.completion?(hexColor) }
        })
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(windowDidResignKey(_:)),
                                               name: NSWindow.didResignKeyNotification,
                                               object: self.screenPickerWindow)

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(windowDidBecomeKey(_:)),
                                               name: NSWindow.didBecomeKeyNotification,
                                               object: self.screenPickerWindow)
        
        NSApplication.shared.activate(ignoringOtherApps: true)
        self.screenPickerWindow!.makeKeyAndOrderFront(self)
    }

    func drop() {
        NSCursor.unhide()
        NotificationCenter.default.removeObserver(self)
        self.screenPickerWindow = nil
    }
}

extension ConverterColorPicker {
    
    @objc public func windowDidBecomeKey(_ notification: Notification) {
        if let obj = notification.object as? ConverterPickColorWindow,
            obj == self.screenPickerWindow {
            obj.acceptsMouseMovedEvents = true
        }
    }

    @objc public func windowDidResignKey(_ notification: Notification) {
        if let obj = notification.object as? ConverterPickColorWindow,
            obj == self.screenPickerWindow {
            self.drop()
        }
    }
}

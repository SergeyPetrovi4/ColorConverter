//
//  AppDelegate.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 30/04/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let converterStatusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let converterPopover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = self.converterStatusBar.button {
            button.image = NSImage(named: "paint_desk")
            button.action = #selector(toggleConverterPopover(_:))
        }
        
        self.converterPopover.contentViewController = ConverterViewController.controller()
        self.converterPopover.behavior = .semitransient
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension AppDelegate {
    
    @objc func toggleConverterPopover(_ sender: Any?) {
        
        if !self.converterPopover.isShown {
            if let button = self.converterStatusBar.button {
                self.converterPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
            
        } else {
            self.converterPopover.performClose(sender)
        }
    }
    
    func showColorPickerMagnify() {        
        ConverterColorPicker.shared.show()
    }
}


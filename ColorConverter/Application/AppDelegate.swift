//
//  AppDelegate.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 30/04/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let converterStatusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let converterPopover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = self.converterStatusBar.button {
            button.image = NSImage(named: "waterdrop")
            button.action = #selector(toggleConverterPopover(_:))
        }
        
        self.converterPopover.contentViewController = ConverterViewController.controller()
        self.converterPopover.behavior = .transient
        
        let launcherAppId = "com.krasiuk.LaunchAtLoginHelper"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty

        if let isLaunch = UserDefaults.standard.value(forKey: "com.krasiuk.colortocode.launch") as? Bool {
            SMLoginItemSetEnabled(launcherAppId as CFString, isLaunch)
            
        } else {
            SMLoginItemSetEnabled(launcherAppId as CFString, false)
        }
        

        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
        }
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
        
        ConverterColorPicker.shared.show { (hexColor) in
            self.toggleConverterPopover(nil)
            
            if let converter = self.converterPopover.contentViewController as? ConverterViewController,
                let hex = hexColor {
                converter.colorTextField.stringValue = hex
                converter.didHitEnterKey(converter.colorTextField)
            }
        }
    }
}

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}


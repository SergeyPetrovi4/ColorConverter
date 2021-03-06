//
//  ConverterViewController.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 30/04/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox
import ServiceManagement

class ConverterViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var colorTextField: NSTextField!
    @IBOutlet weak var convertedColorsTableView: NSTableView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var colorHistoryContainer: NSStackView!
    
    @IBOutlet var contextMenu: NSMenu!
    @IBOutlet weak var launchAtLoginItem: NSMenuItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.convertedColorsTableView.backgroundColor = .clear
        
        if self.colorTextField.stringValue.isEmpty {
            self.scrollView.isHidden = true
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.updateHistoryOfColors()
        
        if let isLaunch = UserDefaults.standard.value(forKey: "com.krasiuk.colortocode.launch") as? Bool {
            self.launchAtLoginItem.state = isLaunch ? .on : .off
        }
    }
    
    // MARK: - Private
    
    private func updateHistoryOfColors() {
        
        self.colorHistoryContainer.isHidden = ColorHistoryManager.shared.colors.isEmpty
        self.colorHistoryContainer.subviews.removeAll()
        
        ColorHistoryManager.shared.colors.enumerated().forEach({
            
            let value = ConverterManager.shared.hexRgb(hex: $0.element)
            let historyContainerView = ColorHistoryContainerView()
            let historyView = ColorHistoryView()
            
            historyContainerView.colorHistory = historyView
            historyContainerView.layoutChildIfNeeded()
                        
            // Update color from history
            historyContainerView.set(color: NSColor(red: value.r, green: value.g, blue: value.b, alpha: value.a), atIndex: $0.offset) { (index, action) in
                
                switch action {
                    
                case .select:
                    self.colorTextField.stringValue = ColorHistoryManager.shared.colors[index]
                    self.convertAndReloadUIData(with: ColorHistoryManager.shared.colors[index])
                    self.colorHistoryContainer.arrangedSubviews.enumerated().forEach({
                        ($0.element as! ColorHistoryContainerView).removeDeleteButton()
                        ($0.element as! ColorHistoryContainerView).colorHistory?.dropAnimation()
                    })
                    
                case .remove:
                    ColorHistoryManager.shared.remove(colorAtIndex: index)
                    self.colorHistoryContainer.subviews.remove(at: index)
                    self.colorHistoryContainer.arrangedSubviews.enumerated().forEach({
                        ($0.element as! ColorHistoryContainerView).update(index: $0.offset)
                    })
                    
                    // Updating UI based on lefted colors history
                    self.colorTextField.stringValue = ""
                    self.didHitEnterKey(self.colorTextField)
                    self.colorHistoryContainer.isHidden = ColorHistoryManager.shared.colors.isEmpty
                    
                case .clean:
                    self.colorHistoryContainer.arrangedSubviews.enumerated().forEach({
                        ($0.element as! ColorHistoryContainerView).removeDeleteButton()
                        ($0.element as! ColorHistoryContainerView).colorHistory?.dropAnimation()
                    })
                }
            }
            
            self.colorHistoryContainer.addArrangedSubview(historyContainerView)
        })        
    }
    
    private func convertAndReloadUIData(with value: String) {
        
        ConverterManager.shared.convertHexToRgb(from: value)

        self.scrollView.isHidden = false
        self.tableView.reloadData()
        self.tableViewHeightConstraint.constant = self.tableView.intrinsicContentSize.height
    }
    
    private func convertAndUpdate(from color: String) {
        
        // Convert and update color from user sent
        self.convertAndReloadUIData(with: color)
        ColorHistoryManager.shared.append(color: color)
        self.updateHistoryOfColors()
    }

    // MARK: - Actions
    
    @IBAction func didClickColorPickerButton(_ sender: NSButton) {
        
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        appDelegate.toggleConverterPopover(nil)
        appDelegate.showColorPickerMagnify()
    }
    
    @IBAction func didHitEnterKey(_ sender: NSTextField) {
        
        if sender.stringValue.isEmpty {
            self.scrollView.isHidden = true
            return
        }
        
        // Convert from hex
        if !sender.stringValue.isEmpty, sender.stringValue.isHexColor {

            self.convertAndUpdate(from: sender.stringValue)
            return
        }
        
        // Convert from rgb
        if !sender.stringValue.hex.isEmpty {
            
            sender.stringValue = "#\(sender.stringValue.hex)"
            self.convertAndUpdate(from: sender.stringValue)
            return
        }
    }
    
    @IBAction func didClickOnSettionsButton(_ sender: NSButton) {
        // Show popover menu
        self.contextMenu.popUp(positioning: self.contextMenu.item(at: 0), at: NSEvent.mouseLocation, in: nil)
    }
    
    @IBAction func didClickLaunchAtLoginItem(_ sender: NSMenuItem) {
        
        sender.state = (sender.state == .on) ? .off : .on
        
        switch sender.state {
        case .on:
            UserDefaults.standard.set(true, forKey: "com.krasiuk.colortocode.launch")
            SMLoginItemSetEnabled("com.krasiuk.LaunchAtLoginHelper" as CFString, true)
            
        case .off:
            UserDefaults.standard.set(false, forKey: "com.krasiuk.colortocode.launch")
            SMLoginItemSetEnabled("com.krasiuk.LaunchAtLoginHelper" as CFString, false)
            
        default:
            return
        }
        
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func didClickQuitMenuItem(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return ConverterManager.shared.descriptions.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("ColumnDescription") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ColorDescriptionCellView"), owner: self) as? ColorDescriptionCellView else {
                return nil
            }
            
            cellView.configure(with: ConverterManager.shared.descriptions[row])
            return cellView
        }
        
        return nil
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 42.0
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, self.tableView.selectedRow >= 0 else {
            return
        }
                
        // Copy selected color description to clipboard
        let description = ConverterManager.shared.descriptions[self.tableView.selectedRow].value
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.string(forType: .string)
        pasteboard.setString(description, forType: .string)
        
        appDelegate.toggleConverterPopover(nil)
        self.tableView.deselectRow(self.tableView.selectedRow)
    }
    
    // MARK: - NSControlTextEditingDelegate
    
    func controlTextDidChange(_ obj: Notification) {
        self.scrollView.isHidden = true
    }
}

extension ConverterViewController {
    
    static func controller() -> NSViewController {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("ConverterViewController")
        
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ConverterViewController else {
          fatalError("Can`t find ConverterViewController")
        }
        
        return viewcontroller
    }
}

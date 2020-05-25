//
//  ConverterViewController.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 30/04/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

class ConverterViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var colorTextField: NSTextField!
    @IBOutlet weak var convertedColorsTableView: NSTableView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var colorHistoryContainer: NSStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.convertedColorsTableView.backgroundColor = .clear
        
        if self.colorTextField.stringValue.isEmpty {
            self.scrollView.isHidden = true
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.updateHistoryOfColors()
    }
    
    // MARK: - Private
    
    private func updateHistoryOfColors() {
        
        self.colorHistoryContainer.isHidden = ColorHistoryManager.shared.colors.isEmpty
        self.colorHistoryContainer.subviews.removeAll()
        
        ColorHistoryManager.shared.colors.enumerated().forEach({
            
            let historyView = ColorHistoryView()
            let value = ConverterManager.shared.hexRgb(hex: $0.element)
            
            // Update color from history
            historyView.set(color: NSColor(red: value.r, green: value.g, blue: value.b, alpha: value.a), atIndex: $0.offset) { (index) in
                self.colorTextField.stringValue = ColorHistoryManager.shared.colors[index]
                self.convertAndReloadUIData(with: ColorHistoryManager.shared.colors[index])
            }
            
            self.colorHistoryContainer.addArrangedSubview(historyView)
        })
    }
    
    private func convertAndReloadUIData(with value: String) {
        
        ConverterManager.shared.convertHexToRgb(from: value)

        self.scrollView.isHidden = false
        self.tableView.reloadData()
        self.tableViewHeightConstraint.constant = self.tableView.intrinsicContentSize.height
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
        
        if !sender.stringValue.isEmpty, sender.stringValue.isHexColor {

            // Convert and update color from user sent
            self.convertAndReloadUIData(with: sender.stringValue)
            ColorHistoryManager.shared.append(color: sender.stringValue)
            self.updateHistoryOfColors()
            
            return
        }

        self.scrollView.isHidden = true
        return
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
        
        guard let textField = obj.object as? NSTextField else {
            return
        }
        
        self.scrollView.isHidden = textField.stringValue.isEmpty
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

//
//  ConverterViewController.swift
//  ColorConverter
//
//  Created by Sergey Krasiuk on 30/04/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Cocoa

class ConverterViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var colorTextField: NSTextField!
    @IBOutlet weak var convertedColorsTableView: NSTableView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.convertedColorsTableView.backgroundColor = .clear
        
        if self.colorTextField.stringValue.isEmpty {
            self.scrollView.isHidden = true
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        
        if !sender.stringValue.isEmpty {

            ConverterManager.shared.convertHexToRgb(from: sender.stringValue)

            self.scrollView.isHidden = false
            self.tableView.reloadData()
            self.tableViewHeightConstraint.constant = self.tableView.intrinsicContentSize.height
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
        return 35.0
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

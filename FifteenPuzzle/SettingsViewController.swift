//
//  SettingsViewController.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/26/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import UIKit

// note: unused but useful use of extensions
extension UITableViewCellAccessoryType {
    func toggleCheckmark() -> UITableViewCellAccessoryType {
        switch self {
        case .Checkmark:
            return .None
        case .None:
            return .Checkmark
        default:
            return .None
        }
    }
}

class SettingsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tableView : UITableView
    var savedSettings: SettingsStorage!
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        
        assert(savedSettings != nil) // savedSettings must be set before this controller is loaded onscreen
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        return Settings.Count.toRaw()
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Settings Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = Settings.fromRaw(indexPath.row)?.description()
        
        if let currentSetting = Settings.fromRaw(indexPath.row) {
            switch currentSetting {
            case .BreadthFirstSearch, .AStar:
                cell.accessoryType = (currentSetting == savedSettings.savedSearchSetting) ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
                cell.selectionStyle = UITableViewCellSelectionStyle.Default
            default:
                break // ie. do nothing
        }
        }

        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let currentSetting = Settings.fromRaw(indexPath.row) {
            switch currentSetting {
            case .BreadthFirstSearch, .AStar:
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                deselectOtherSettings(currentSetting, tableView: tableView)
            default:
                break
            }
            
            savedSettings.savedSearchSetting = currentSetting
        }
    }
    
    func deselectOtherSettings(currentSetting: Settings, tableView: UITableView) {
        for rawValue in 0..Settings.Count.toRaw() {
            if let eachSetting = Settings.fromRaw(rawValue) {
                switch eachSetting {
                case .BreadthFirstSearch, .AStar:
                    if currentSetting != eachSetting {
                        let indexPath = NSIndexPath(forRow: rawValue, inSection: 0)
                        let cell = tableView.cellForRowAtIndexPath(indexPath)
                        cell.accessoryType = UITableViewCellAccessoryType.None
                    }
                default:
                    break
                }
            }
        }
    }

}

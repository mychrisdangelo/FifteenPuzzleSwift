//
//  SettingsViewController.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/26/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import UIKit

enum Settings: Int {
    case BreadthFirstSearch = 0, AStar
    case ShuffleAmount
    case Count
    
    func description() -> String {
        switch self {
        case .BreadthFirstSearch:
            return "Breadth First Search"
        case .AStar:
            return "A*"
        case .ShuffleAmount:
            return "Number of Moves to Shuffle"
        default:
            return String(self.toRaw())
        }
    }
}

class SettingsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tableView : UITableView
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
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
        
        return cell
    }

}

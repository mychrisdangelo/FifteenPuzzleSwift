//
//  SettingsStorage.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/26/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import Foundation

enum Settings: Int {
    case BreadthFirstSearch = 0, AStar
    case Count
    
    func description() -> String {
        switch self {
        case .BreadthFirstSearch:
            return "Breadth First Search"
        case .AStar:
            return "A*"
        default:
            return String(self.toRaw())
        }
    }
}

class SettingsStorage {
    
    let savedSearchSettingKey = "savedSearchSettingKey"
    
    var savedSearchSetting: Settings {
    get {
        if let rawValue = NSUserDefaults.standardUserDefaults().objectForKey(savedSearchSettingKey) as? Int {
            if let savedSetting = Settings.fromRaw(rawValue) {
                return savedSetting
            }
        }
        
        let newSetting = Settings.AStar
        NSUserDefaults.standardUserDefaults().setObject(newSetting.toRaw(), forKey: savedSearchSettingKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        return newSetting
    }
    set {
        NSUserDefaults.standardUserDefaults().setObject(newValue.toRaw(), forKey: savedSearchSettingKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    }
    
}


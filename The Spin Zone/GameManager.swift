//
//  GameManager.swift
//  The Spin Zone
//
//  Created by Nicholas Grana on 10/17/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import UIKit

typealias Theme = UIColor

extension Array {
    
    func nextIndex(at index: Int) -> Int {
        if index >= count {
            return 0
        }
        return index
    }
    
    func nextIndexElement(at index: Int) -> Element {
        return self[nextIndex(at: index)]
    }
    
}

extension Theme {
    static let gray = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.00)
    static let red = UIColor(red:0.54, green:0.01, blue:0.04, alpha:1.00)
    static let orange = UIColor(red:0.87, green:0.31, blue:0.10, alpha:1.00)
    static let yellow = UIColor(red:1.00, green:0.64, blue:0.00, alpha:1.00)
    static let green = UIColor(red:0.19, green:0.67, blue:0.15, alpha:1.00)
    static let blue = UIColor(red:0.00, green:0.43, blue:0.73, alpha:1.00)
    static let purple = UIColor(red:0.18, green:0.13, blue:0.40, alpha:1.00)
    static let pink = UIColor(red:0.94, green:0.24, blue:0.43, alpha:1.00)
}

class GameManager {
    
    let levels = LevelManager()
    let themes = ThemeManager()
    
    // let barriers = [Int: BarrierPath]()
    // let gates = [Int: GatePath]()
    
    var viewSize: CGSize
    
    init(size: CGSize) {
        self.viewSize = size
        
        loadGates()
        loadBarriers()
    }
    
    func loadBarriers() {
        for level in 1...6 {
            // barriers[level] = BarrierPath(level: level)
        }
    }
    
    func loadGates() {
        for level in 1...6 {
            // gates[level] = GatePath(level: level)
        }
    }
    
}

class LevelManager {
    
    var next: Int {
        let fromConfig = UserDefaults.standard.integer(forKey: "score")
        return (fromConfig == 0 ? 1 : fromConfig) + 1
    }
    
    var current: Int {
        return next - 1
    }
    
}

class ThemeManager {
    
    let availableThemes = [
        Theme.gray,
        UIColor.red,
        UIColor.orange,
        UIColor.yellow,
        UIColor.green,
        UIColor.blue,
        UIColor.purple,
        UIColor.pink
    ]
    
    var current: Theme {
        return availableThemes[index]
    }
    
    var next: Theme {
        return availableThemes.nextIndexElement(at: index + 1)
    }
    
    var index: Int {
        get {
            return UserDefaults.standard.integer(forKey: "color-index")
        }
        set {
            UserDefaults.standard.set(availableThemes.nextIndex(at: newValue), forKey: "color-index")
        }
    }
    
}

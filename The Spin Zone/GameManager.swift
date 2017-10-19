//
//  GameManager.swift
//  The Spin Zone
//
//  Created by Nicholas Grana on 10/17/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import UIKit

class GameManager {
    
    // MARK: Properties
    
    let levels = LevelManager()
    let themes = ThemeManager()
    
    var barriers = [Int: BarrierPath]()
    var gates = [Int: GatePath]()
    
    var viewSize: CGSize
    
    let angle = -60

    lazy var lineWidth: CGFloat = {
        return (width * 0.24) / 10
    }()
    lazy var scaledRadius: CGFloat = {
        return (width * 0.27) / 2
    }()
    lazy var xScaledIncrease: CGFloat = {
        return (width * 0.53) / 8
    }()
    lazy var ballRadius: CGFloat = {
        return width * 0.05
    }()
    lazy var width: CGFloat = {
        return min(viewSize.width * 0.95, viewSize.height * 0.95)
    }()
    
    // MARK: Constructors
    
    // create a new manager and initialize everything
    init(size: CGSize) {
        self.viewSize = size
        
        loadGates()
        loadBarriers()
    }
    
    func loadBarriers() {
        for level in 1...6 {
            barriers[level] = BarrierPath(game: self, level: level)
        }
    }
    
    func loadGates() {
        for level in 1...6 {
            gates[level] = GatePath(game: self, level: level)
        }
    }
    
}

class LevelManager {
    
    // convience for getting the next level
    var next: Int {
        return current + 1
    }
    
    // gets current level from storage
    var current: Int {
        let fromConfig = UserDefaults.standard.integer(forKey: "score")
        return (fromConfig == 0 ? 1 : fromConfig)
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
    
    // current theme applied
    var current: Theme {
        return availableThemes[index]
    }
    
    // next theme that may be applied
    var next: Theme {
        return availableThemes.nextIndexElement(at: index + 1)
    }
    
    // current index of theme relative to availableThemes
    var index: Int {
        get {
            return UserDefaults.standard.integer(forKey: "color-index")
        }
        set {
            UserDefaults.standard.set(availableThemes.nextIndex(at: newValue), forKey: "color-index")
        }
    }
    
}

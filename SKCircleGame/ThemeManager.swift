//
//  ThemeManager.swift
//  Spin Zone
//
//  Created by Nicholas Grana on 6/3/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class ThemeManager {
    
    // scenes that are to be updated on color change
    var updateScenes = [ForceTouchScene]()
    
    var current = UIColor.grayThemeBackground
    
    let themes = [
        UIColor.grayThemeBackground,
        UIColor.redThemeBackground,
        UIColor.orangeThemeBackground,
        UIColor.yellowThemeBackground,
        UIColor.greenThemeBackground,
        UIColor.blueThemeBackground,
        UIColor.purpleThemeBackground,
        UIColor.pinkThemeBackground
    ]
    
    var currentIndex: Int {
        get {
            return UserDefaults.standard.integer(forKey: "color-index")
        }
        set {
            let v = newValue
            UserDefaults.standard.set(v + 1 > themes.count - 1 ? 0 : v + 1, forKey: "color-index")
        }
        
    }
    
    var colorActions: [SKAction] {
        return themes.map {
            return SKAction.sequence([SKAction.run{ self.currentIndex += 1 }, SKAction.colorize(with: $0, colorBlendFactor: 1.0, duration: 15.0), ])
        }
    }
    
    var currentColor: UIColor {
        current = themes[currentIndex]
        return themes[currentIndex]
    }
    
    var nextColor: UIColor {
        return themes[nextIndex]
    }
    
    var nextIndex: Int {
        return currentIndex + 1 > themes.count - 1 ? 0 : currentIndex + 1
    }
    
    var ballNextIndex: Int {
        return nextIndex + 1 > themes.count - 1 ? 0 : nextIndex + 1
    }
    
    func updateColors() {
        for scene in updateScenes {
            scene.transitionBackground()
        }
    }
    
}

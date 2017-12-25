//
//  ThemeManager.swift
//  Spin Zone
//
//  Created by Nicholas Grana on 6/3/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class ThemeManager {
    
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
            let index =  UserDefaults.standard.integer(forKey: "color-index")
            return index < 0 || index > themes.count - 1 ? 0 : index
        }
        set {
            let v = newValue
            if (v < 0) {
                UserDefaults.standard.set(0, forKey: "color-index")
            } else {
                UserDefaults.standard.set(v > themes.count - 1 ? 0 : v, forKey: "color-index")
            }
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
    
}

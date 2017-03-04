//
//  PauseScene.swift
//  Spin Zone
//
//  Created by Nicholas Grana on 3/1/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class PauseScene: ClickableScene {
    
    override func didMove(to view: SKView) {
        // self.model = MenuModel(buttons: ["": (scene:)])
        self.sceneTitle(name: "Paused")
        
        self.createButtons()
    }
    
    func createButtons() {

    }
    
}

//
//  MenuModel.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/18/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class TransitionHandler {
    
    // for example, a menu button would be stored as: "menu", scene: Scene.menu, transition: SKTransition.up
    let buttons: Dictionary<String, (scene: DestinationScene, direction: SKTransitionDirection?)>
    // stores the scene for buttons like "go back"
    let fromScene: SKScene
    
    // since all values have same duration, just supply direction. nil means the direction is dynamic
    init(buttons: Dictionary<String, (scene: DestinationScene, direction: SKTransitionDirection?)>, fromScene: SKScene) {
        self.buttons = buttons
        self.fromScene = fromScene
    }
    
    func create(scene: DestinationScene, current: SKScene) -> SKScene {
        let newScene: SKScene!
        
        switch scene {
            case .game:
                newScene = GameScene(size: Constants.currentSize)
            case .start:
                newScene = GameStartMenu(size: Constants.currentSize)
            case .about:
                newScene = AboutScene(size: Constants.currentSize)
            case .pause:
                newScene = PauseScene(size: Constants.currentSize)
            case .dynamic:
                newScene = fromScene
        }
        newScene.backgroundColor = current.backgroundColor
        // Set the scale mode to scale to fit the window
        newScene.scaleMode = .aspectFill
        return newScene
    }
    
}

enum DestinationScene {
    case game
    case start
    case about
    case pause
    case dynamic // for buttons like "Go Back" which does not have a set destination scene
}

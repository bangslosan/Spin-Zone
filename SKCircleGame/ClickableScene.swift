//
//  ClickableScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 1/3/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class ClickableScene: ForceTouchScene {

    var transitionHandler: TransitionHandler!
    
    var prevSelected: ButtonSprite? = nil
    var selected: ButtonSprite? = nil
    
    var touching = false
    var makingCricle = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touching {
            return
        }
        
        touching = true
        if let button = buttonFrom(touches: touches) {
            if prevSelected == nil {
                prevSelected = button
            }
            selected = button
            button.pressed()
        } else {
            super.touchesMoved(touches, with: event)
            makingCricle = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let button = buttonFrom(touches: touches), prevSelected == button {
            selected = button
            button.pressed()
        } else {
            if selected != nil {
                prevSelected = selected
                selected?.letGo()
                selected = nil
            }
        }
        
        if makingCricle {
            super.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let clicked = selected {
            if let name = clicked.name?.lowercased() {
                clicked.runOnClick()
                clicked.letGo()
                
                let button = transitionHandler.buttons[name]
                if let button = button {
                    let newScene = transitionHandler.create(scene: button.scene, current: self)
                    let transition = SKTransition.push(with: button.direction!, duration: 0.4)
                    transition.pausesIncomingScene = true
                    self.view!.presentScene(newScene, transition: transition)
                    // return to pretend creating / editing of superclass's circle creation
                    return
                }
                
                prevSelected = nil
                selected = nil
                touching = false
                makingCricle = false
                return
            }
        }
        
        prevSelected = nil
        selected = nil
        touching = false
        makingCricle = false
        super.touchesEnded(touches, with: event)
    }
    
}

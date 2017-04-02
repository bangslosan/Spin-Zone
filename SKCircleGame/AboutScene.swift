//
//  ShopScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 1/19/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class AboutScene: ClickableScene {
    
    var buttonPosition: CGPoint!

    override func didMove(to view: SKView) {
        if (TransitionHandler.previousScene == self) {
            return
        }
        
        self.transitionHandler = TransitionHandler(buttons: ["go back": (scene: .dynamic, direction: .up)])
        self.sceneTitle(name: "About")
        
        self.createText()
        self.createButtons()
    }
    
    func createButtons() {
        let menu = ButtonSprite(title: "Go Back", under: nil, position: buttonPosition)
        self.addChild(menu)
        self.addChild(menu.label)
    }
    
    func createText() {
        addText(textBlocks: "To play, simply touch the screen when the ball lines up with the opening of the next level while avoiding the white circles.", "To change the color, push into the background of a menu screen.", "You will earn 1 Retry every 10 Levels, which can be used to continue from your last spot.")
    }
    
    func addText(textBlocks: String...) {
        var pastLabelPosition: CGPoint?
        var pastLabelHeight: CGFloat?
        
        for block in textBlocks {
            let position = CGPoint(x: Constants.sceneTitlePosition.x, y: pastLabelPosition != nil ? (pastLabelPosition!.y - pastLabelHeight! - 20.yScaled) : Constants.sceneTitlePosition.y - 40.yScaled)
            let label = SKMultilineLabel(text: block, labelWidth: Int(Constants.currentSize.width) - 5, pos: position)
            label.alpha = 0.65
            self.addChild(label)
            
            pastLabelPosition = position
            pastLabelHeight = CGFloat(label.labelHeight)
        }
        
        buttonPosition = CGPoint(x: pastLabelPosition!.x, y: pastLabelPosition!.y - pastLabelHeight! - 20.yScaled - 50.yScaled)
    }
    
}

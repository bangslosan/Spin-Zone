//
//  DynamicScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 5/13/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class DynamicScene: PlayableClickScene {

    var dynamicBackground: SKSpriteNode!

    override func didMove(to view: SKView) {
        dynamicBackground = SKSpriteNode(color: backgroundColor, size: CGSize(width: self.frame.size.width * 2, height: self.frame.size.height * 2))
        dynamicBackground.zPosition = -5
        addChild(dynamicBackground)

        dynamicAnimate(sprite: dynamicBackground)
    }

    func dynamicAnimate(sprite: SKSpriteNode, startingFromIndex index: Int = 0) {
        var startArray = [SKAction]()
        for i in index...SpinZoneManager.manager.themes.count - 1 {
            startArray.append(SpinZoneManager.manager.colorActions[i])
        }
        sprite.run(SKAction.sequence([SKAction.sequence(startArray), SKAction.repeatForever(SKAction.sequence(SpinZoneManager.manager.colorActions))]))
    }

}
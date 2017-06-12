//
//  BallSprite.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/10/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit
import CoreGraphics

class BallSprite: SKSpriteNode {

    init(on zoneLevel: SpinZoneLevel) {
        let spriteShape = SKShapeNode(circleOfRadius: Constants.ballRadius)
        spriteShape.fillColor = UIColor.white
        spriteShape.strokeColor = UIColor.white
        let texture = SKView().texture(from: spriteShape)
        // TODO: have color start off as nextColor instead of white without having blend issues
        // texture.color = SpinZoneManager.themes.nextColor
        
        super.init(texture: texture, color: UIColor.white, size: CGSize(width: Constants.ballRadius, height: Constants.ballRadius))
        self.size = CGSize(width: Constants.ballRadius, height: Constants.ballRadius)

        self.color = SpinZoneManager.themes.nextColor
        setup(on: zoneLevel)
    }

    func setup(on zoneLevel: SpinZoneLevel) {
        func setupPhysics() {
            let physics = SKPhysicsBody(circleOfRadius: (Constants.ballRadius - 2.xScaled) / 2)
            physics.affectedByGravity = false
            physics.collisionBitMask = 0
            physics.categoryBitMask = Catigory.ball.rawValue
            physics.contactTestBitMask = Contact.track.rawValue | Contact.goal.rawValue
            self.physicsBody = physics
        }
        func setupBall() {
            run(followAction(on: zoneLevel, rad: CGFloat(CGFloat.radian(fromDegree: Constants.angle / 2) + zoneLevel.zRotation)))

            zoneLevel.gameModel.scene.dynamicAnimate(sprite: self, startingFromIndex: SpinZoneManager.themes.ballNextIndex)
        }

        setupPhysics()
        setupBall()
    }

    func update(on zoneLevel: SpinZoneLevel) {
        run(SKAction.repeatForever(followAction(on: zoneLevel, rad: atan2(position.y - Constants.center.y, position.x - Constants.center.x))))
    }

    func followAction(on zoneLevel: SpinZoneLevel, rad: CGFloat) -> SKAction {
        let path = UIBezierPath(arcCenter: Constants.center, radius: CGFloat(Constants.xScaledIncrease + Constants.scaledRadius), startAngle: rad, endAngle: CGFloat.radian(fromDegree: 360) + rad, clockwise: true)
        var action = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, duration: zoneLevel.time)
        if zoneLevel.clockwise {
            action = action.reversed()
        }

        return SKAction.repeatForever(action)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

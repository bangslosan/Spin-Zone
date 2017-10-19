//
//  BallNode.swift
//  The Spin Zone
//
//  Created by Nicholas Grana on 10/18/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    // MARK: Properties
    
    let game: GameManager
    
    // MARK: Constructors
    
    init(game: GameManager, on level: Level) {
        self.game = game
        
        let spriteShape = SKShapeNode(circleOfRadius: game.ballRadius)
        spriteShape.fillColor = UIColor.white
        spriteShape.strokeColor = UIColor.white
        let texture = SKView().texture(from: spriteShape)
        
        super.init(texture: texture, color: UIColor.white, size: CGSize(width: game.ballRadius, height: game.ballRadius))
        self.size = CGSize(width: game.ballRadius, height: game.ballRadius)
        self.color = UIColor.white
        
        setup(on: level)
    }
    
    // MARK: Functions
    
    func setup(on level: Level) {
        func setupPhysics() {
            let physics = SKPhysicsBody(circleOfRadius: (game.ballRadius - 2.xScaled) / 2)
            physics.affectedByGravity = false
            physics.collisionBitMask = 0
            physics.categoryBitMask = Catigory.ball.rawValue
            physics.contactTestBitMask = Contact.track.rawValue | Contact.goal.rawValue
            self.physicsBody = physics
        }
        func setupBall() {
            run(followAction(on: level, rad: CGFloat(CGFloat.radian(fromDegree: game.angle / 2) + level.zRotation)))
        }
        
        setupPhysics()
        setupBall()
    }
    
    func update(on level: Level) {
        run(SKAction.repeatForever(followAction(on: level, rad: atan2(position.y, position.x))))
    }
    
    func followAction(on zoneLevel: Level, rad: CGFloat) -> SKAction {
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: CGFloat(game.xScaledIncrease + game.scaledRadius), startAngle: rad, endAngle: CGFloat.radian(fromDegree: 360) + rad, clockwise: true)
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

//
//  ArchPath.swift
//  The Spin Zone
//
//  Created by Nicholas Grana on 10/18/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class Arc {
    
    // MARK: Properties
    
    // level of the arc, used to calculate size
    let level: Int
    // radius of arc line paths
    let radius: CGFloat
    // start of arc angle draw
    let startAngle: CGFloat
    // end of arc angle draw
    let endAngle: CGFloat
    // drawn clockwise or counter clockwise
    let clockwise: Bool
    // color of arc
    let color: UIColor
    // crop used to set exact view size
    let crop: CGRect?
    
    // wraps the inside of the center the arc path (calculated with radius - line width / 2)
    lazy var innerPath: UIBezierPath = {
        return UIBezierPath(arcCenter: CGPoint.zero, radius: self.radius - (game.lineWidth / 2), startAngle: self.startAngle, endAngle: self.endAngle, clockwise: self.clockwise)
    }()
    
    // wraps the outside of the center of the arc path (calculated with radius + line width / 2)
    lazy var outerPath: UIBezierPath = {
        return UIBezierPath(arcCenter: CGPoint.zero, radius: self.radius + (game.lineWidth / 2), startAngle: self.startAngle, endAngle: self.endAngle, clockwise: self.clockwise)
    }()
    
    // center of the arc path
    lazy var centerPath: UIBezierPath = {
        return UIBezierPath(arcCenter: CGPoint.zero, radius: self.radius, startAngle: self.startAngle, endAngle: self.endAngle, clockwise: self.clockwise)
    }()
    
    // constructs actual shape from UIBezierPath and properties
    lazy var shape: SKShapeNode = {
        let shape = SKShapeNode(path: self.centerPath.cgPath)
        shape.lineWidth = game.lineWidth
        shape.strokeColor = self.color
        return shape
    }()
    
    // turns shape into an SKTexture to later be applied as an SKSpriteNode
    lazy var texture: SKTexture = {
        if let c = self.crop {
            return SKView().texture(from: self.shape, crop: c)!
        } else {
            return  SKView().texture(from: self.shape, crop: self.outerPath.bounds)!
        }
    }()
    
    let game: GameManager
    
    // MARK: Constructors
    
    init(game: GameManager, level: Int, radius: CGFloat, degreeStart: Int, degreeEnd: Int, clockwise: Bool, color: UIColor, crop: CGRect? = nil) {
        self.game = game
        self.level = level
        self.radius = radius
        self.startAngle = CGFloat.radian(fromDegree: degreeStart)
        self.endAngle = CGFloat.radian(fromDegree: degreeEnd)
        self.clockwise = clockwise
        self.color = color
        self.crop = crop
    }
    
}

class GatePath: Arc {
    
    // MARK: Constructors
    
    init(game: GameManager, level: Int) {
        let outerPath = UIBezierPath(arcCenter: CGPoint.zero, radius: CGFloat(((game.scaledRadius * CGFloat(level)) + (game.scaledRadius * 2 + game.lineWidth))), startAngle: CGFloat.radian(fromDegree: game.angle), endAngle: CGFloat.radian(fromDegree: 360), clockwise: false)
        super.init(game: game, level: level, radius: (game.xScaledIncrease * CGFloat(level)) + game.scaledRadius, degreeStart: 0, degreeEnd: game.angle, clockwise: false, color: UIColor.white, crop: outerPath.bounds)
        shape.alpha = 0.15
    }
    
}

class BarrierPath: Arc {
    
    // MARK: Constructors
    
    init(game: GameManager, level: Int) {
        super.init(game: game, level: level, radius: (game.xScaledIncrease * CGFloat(level)) + game.scaledRadius, degreeStart: game.angle, degreeEnd: 360, clockwise: false, color: UIColor.white)
    }
    
}

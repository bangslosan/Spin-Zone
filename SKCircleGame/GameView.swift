//
//  GameView.swift
//  Spin Zone
//
//  Created by Nicholas Grana on 4/30/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit
import UIKit

public class GameView: SKView {

    let level: Int

    var gates = [Gate]()
    var barriers = [Barrier]()

    init(level: Int) {
        self.level = level
        super.init(frame: CGRect.zero) // TODO: set to 90% of highest between width and height
        setup()
    }

    func setup() {
        func setupBall() {

        }

        func setupGates() {

        }

        func setupBarriers() {

        }

        setupGates()
        setupBarriers()
        setupBall()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Arc {

    let level: Int
    let radius: CGFloat
    let startAngle: CGFloat
    let endAngle: CGFloat
    let clockwise: Bool
    let color: UIColor
    let crop: CGRect?

    lazy var innerPath: UIBezierPath = {
        return UIBezierPath(arcCenter: CGPoint.zero, radius: self.radius - (Constants.lineWidth / 2), startAngle: self.startAngle, endAngle: self.endAngle, clockwise: self.clockwise)
    }()
    lazy var outerPath: UIBezierPath = {
        return UIBezierPath(arcCenter: CGPoint.zero, radius: self.radius + (Constants.lineWidth / 2), startAngle: self.startAngle, endAngle: self.endAngle, clockwise: self.clockwise)
    }()
    lazy var centerPath: UIBezierPath = {
        return UIBezierPath(arcCenter: CGPoint.zero, radius: self.radius, startAngle: self.startAngle, endAngle: self.endAngle, clockwise: self.clockwise)
    }()

    lazy var shape: SKShapeNode = {
        let shape = SKShapeNode(path: self.centerPath.cgPath)
        shape.lineWidth = Constants.lineWidth
        shape.strokeColor = self.color
        return shape
    }()
    lazy var texture: SKTexture = {
        if let c = self.crop {
            return SKView().texture(from: self.shape, crop: c)!
        } else {
            return  SKView().texture(from: self.shape, crop: self.outerPath.bounds)!
        }
    }()

    init(level: Int, radius: CGFloat, degreeStart: Int, degreeEnd: Int, clockwise: Bool, color: UIColor, crop: CGRect? = nil) {
        self.level = level
        self.radius = radius
        self.startAngle = CGFloat.radian(fromDegree: degreeStart)
        self.endAngle = CGFloat.radian(fromDegree: degreeEnd)
        self.clockwise = clockwise
        self.color = color
        self.crop = crop
    }

}

class SpinZoneLevel: SKSpriteNode {

    let level: Int
    let barrierSprite: BarrierSprite
    let gateSprite: GateSprite

    init(level: Int, barrier: BarrierSprite, gate: GateSprite) {
        self.level = level
        self.barrierSprite = barrier
        self.gateSprite = gate

        super.init(texture: barrierSprite.barrier.texture, color: UIColor.white, size: barrierSprite.barrier.texture.size())
        self.addChild(barrierSprite)
        self.addChild(gateSprite)

        self.position = Constants.center
        barrierSprite.position = Constants.center
        gate.position = Constants.center
    }

    func shrink() {
        level -= 1

        if level <= 0 {
            fadeOut()
        } else {
            let scale: CGFloat!
            let shape: SKShapeNode!

            if self is TrackSprite {
                scale = TrackSprite.trackPathTextures[level]!.texture.size().height / TrackSprite.trackPathTextures[level + 1]!.texture.size().height
                shape = PathTexture.trackShapes[level + 1]!.copy() as! SKShapeNode

                if level == 1 {
                    model.levelOneTrack = (self as! TrackSprite)
                    model.updateBall()
                }
                (self as! TrackSprite).goalSprite.shrink()
            } else {
                scale = GoalSprite.goalPathTextures[level]!.texture.size().height / GoalSprite.goalPathTextures[level + 1]!.texture.size().height
                shape = PathTexture.goalShapes[level + 1]!.copy() as! SKShapeNode
                shape.alpha = 0.15
                if level == 1 {
                    model.levelOneGoal = (self as! GoalSprite)
                    model.updateBall()
                }
            }

        }
    }

    func fadeOut() {

    }

}

class GateSprite: SKSpriteNode {

    static var gates = [Int: Gate]()

    let gate: Gate

    init(level: Int) {
        gate = GateSprite.gates[level]!
    }

    static func loadGates() {
        for level in 1...6 {
            gates[level] = Gate(level: level)
        }
    }
}

class BarrierSprite: SKSpriteNode {

    static var barriers = [Int: Barrier]()

    let barrier: Barrier

    init(level: Int) {
        barrier = BarrierSprite.barriers[level]!
    }

    func shrink() {
        level -= 1

        let smallArc: Barrier = BarrierSprite.barriers[level]!
        let bigArc = BarrierSprite.barriers[level + 1]!
        let scale = smallArc.texture.size().height / bigArc.texture.size().height
        let shape = bigArc.shape.copy() as! SKShapeNode

        shape.alpha = 0.15 // TODO: is this needed?
        if level == 1 {
            // TODO: maybe use subscripts instead?
            model.levelOneGoal = (self as! GoalSprite)
            model.updateBall()
        }

        let finalLineWidth = initialLineWidth / scale
        let animationDuration = 0.1625

        let scaleAction = SKAction.scale(by: scale, duration: animationDuration)

        let lineWidthAction = SKAction.customAction(withDuration: animationDuration) { (shapeNode, time) in
            if let shape = shapeNode as? SKShapeNode {
                let progress = time / CGFloat(animationDuration)
                shape.lineWidth = initialLineWidth + progress * (finalLineWidth - initialLineWidth)
            }
        }
    }

    static func loadBarriers() {
        for level in 1...6 {
            barriers[level] = Barrier(level: level)
        }
    }

}


class Gate: Arc {

    init(level: Int) {
        let outerPath = UIBezierPath(arcCenter: CGPoint.zero, radius: CGFloat(((Constants.scaledRadius * CGFloat(level)) + (Constants.scaledRadius * 2 + Constants.lineWidth))), startAngle: CGFloat.radian(fromDegree: Constants.angle), endAngle: CGFloat.radian(fromDegree: 360), clockwise: false)
        super.init(level: level, radius: (Constants.xScaledIncrease * CGFloat(level)) + Constants.scaledRadius, degreeStart: 0, degreeEnd: Constants.angle, clockwise: false, color: UIColor.white, crop: outerPath.bounds)
        shape.alpha = 0.15
    }

}

class Barrier: Arc {

    init(level: Int) {
        super.init(level: level, radius: (Constants.xScaledIncrease * CGFloat(level)) + Constants.scaledRadius, degreeStart: Constants.angle, degreeEnd: 360, clockwise: false, color: UIColor.white)
    }

}
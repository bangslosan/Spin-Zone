//
//
//  Paths.swift
//  Spin Zone
//
//  Created by Nicholas Grana on 5/3/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//
import SpriteKit

/*
    Used to create the 2 paths that make up a BarrierSprite and GateSprite for a SpinZoneLevel
*/

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


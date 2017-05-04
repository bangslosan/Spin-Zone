//
//  GameView.swift
//  Spin Zone
//
//  Created by Nicholas Grana on 4/30/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit
import UIKit

// TODO: use this to replace a lot of stuff inside GameModel to increase organization
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

    func createBall(on zoneLevel: SpinZoneLevel) {
        let time = zoneLevel.time
        ball = BallSprite(color: DynamicBackground.nextColor, view: scene.view!)
        ball.zPosition = 2
        ball.position = Constants.center
        scene.addChild(ball)

        let radians = CGFloat(CGFloat.radian(fromDegree: Constants.angle / 2) + zoneLevel.zRotation)

        let track = UIBezierPath(arcCenter: Constants.center, radius: CGFloat(Constants.xScaledIncrease + Constants.scaledRadius), startAngle: radians, endAngle: (radians + CGFloat(Double.pi * 2)), clockwise: true)
        ball.action = SKAction.follow(track.cgPath, asOffset: false, orientToPath: true, duration: time!).reversed()
    }

    func createBall(time: Double, rev: Bool) {
        ball = BallSprite(color: DynamicBackground.nextColor, view: scene.view!)
        ball.zPosition = 2
        ball.position = Constants.center
        scene.addChild(ball)

        // half the arc angle = its center
        let radians = CGFloat(CGFloat.radian(fromDegree: Constants.angle / 2) + levelOne.zRotation)

        let track: UIBezierPath = UIBezierPath(arcCenter: Constants.center, radius: CGFloat(Constants.xScaledIncrease + Constants.scaledRadius), startAngle: radians + levelOne.zRotation, endAngle:  (radians + CGFloat(Double.pi * 2)), clockwise: true)
        var action: SKAction = SKAction.follow(track.cgPath, asOffset: false, orientToPath: true, duration: TimeInterval(time))

        if rev {
            action = action.reversed()
        }

        ball.action = action
    }

    func updateBall() {
        let dx = ball.position.x - Constants.center.x
        let dy = ball.position.y - Constants.center.y

        let rad = atan2(dy, dx)

        let path = UIBezierPath(arcCenter: Constants.center, radius: CGFloat(Constants.xScaledIncrease + Constants.scaledRadius), startAngle: rad, endAngle: CGFloat.radian(fromDegree: 360) + rad, clockwise: true)

        var action = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, duration: TimeInterval(levelOne.time))

        if levelOne.clockwise! {
            action = action.reversed()
        }

        ball.action = action
    }

    func createTracks() {
        for level in 1...(self.scoreLabel.score + 1 > 5 ? 5 : self.scoreLabel.score + 1) {
            let spinZoneLevel = SpinZoneLevel(level: level, model: self)
            scene.addChild(spinZoneLevel)

            if level == 1 {
                createBall(on: spinZoneLevel)
            }

        }
    }

    func applyTrackPhysics() {
        let barrierPhysics = SKPhysicsBody(edgeChainFrom: SpinZoneManager.manager.barriers[1]!.centerPath.cgPath)
        barrierPhysics.affectedByGravity = false
        barrierPhysics.collisionBitMask = 0
        barrierPhysics.categoryBitMask = Catigory.track.rawValue
        barrierPhysics.contactTestBitMask = Contact.ball.rawValue
        levelOne.barrierSprite.physicsBody = barrierPhysics
    }

    func applyGoalPhysics() {
        let gatePhysics = SKPhysicsBody(edgeChainFrom: SpinZoneManager.manager.gates[1]!.centerPath.cgPath)
        gatePhysics.affectedByGravity = false
        gatePhysics.collisionBitMask = 0
        gatePhysics.categoryBitMask = Catigory.goal.rawValue
        gatePhysics.contactTestBitMask = Contact.ball.rawValue
        levelOne.gateSprite.physicsBody = gatePhysics
    }
}
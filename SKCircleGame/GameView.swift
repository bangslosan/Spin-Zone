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
    let gameModel: GameModel

    var ball: BallSprite!

    var levelOne: SpinZoneLevel! {
        for node in gameModel.scene.children {
            if let zone = node as? SpinZoneLevel {
                if zone.level == 1 {
                    return zone
                }
            }
        }
        return nil
    }

    init(level: Int, model: GameModel) {
        self.level = level
        self.gameModel = model
        super.init(frame: CGRect.zero) // TODO: set to 90% of highest between width and height
        setup()
    }

    func setup() {
        func setupBall() {
            ball = BallSprite(color: DynamicBackground.nextColor, on: levelOne)
            ball.zPosition = 2
            ball.position = Constants.center
            gameModel.scene.addChild(ball)
        }

        func setupLevels() {
            for level in 1...(level + 1 > 5 ? 5 : level + 1) {
                let spinZoneLevel = SpinZoneLevel(level: level, model: gameModel)
                gameModel.scene.addChild(spinZoneLevel)
            }
        }

        setupLevels()
        setupBall()
    }

    func applyBarrierPhysics() {
        let barrierPhysics = SKPhysicsBody(edgeChainFrom: SpinZoneManager.manager.barriers[1]!.centerPath.cgPath)
        barrierPhysics.affectedByGravity = false
        barrierPhysics.collisionBitMask = 0
        barrierPhysics.categoryBitMask = Catigory.track.rawValue
        barrierPhysics.contactTestBitMask = Contact.ball.rawValue
        levelOne.barrierSprite.physicsBody = barrierPhysics
    }

    func applyGatePhysics() {
        let gatePhysics = SKPhysicsBody(edgeChainFrom: SpinZoneManager.manager.gates[1]!.centerPath.cgPath)
        gatePhysics.affectedByGravity = false
        gatePhysics.collisionBitMask = 0
        gatePhysics.categoryBitMask = Catigory.goal.rawValue
        gatePhysics.contactTestBitMask = Contact.ball.rawValue
        levelOne.gateSprite.physicsBody = gatePhysics
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
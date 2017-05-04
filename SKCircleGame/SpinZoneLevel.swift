//
// Created by Nicholas Grana on 5/3/17.
// Copyright (c) 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class SpinZoneLevel: SKNode {

    var level: Int {
        didSet {
            if level == 1 {
                gameModel.updateBall()
            }
        }
    }
    let gameModel: GameModel
    var barrierSprite: BarrierSprite!
    var gateSprite: GateSprite!
    var clockwise: Bool!
    var time: Double!
    var action: SKAction!

    init(level: Int, model: GameModel) {
        self.level = level
        self.gameModel = model

        super.init()

        self.barrierSprite = BarrierSprite(zoneLevel: self)
        self.gateSprite = GateSprite(zoneLevel: self)

        self.addChild(barrierSprite)
        self.addChild(gateSprite)

        self.position = Constants.center
        barrierSprite.position = CGPoint.zero
        gateSprite.position = CGPoint.zero

        animate()
    }

    init(from: SpinZoneLevel) {
        self.level = from.level
        self.gameModel = from.gameModel
        self.action = from.action
        self.time = from.time
        self.clockwise = from.clockwise

        super.init()

        self.barrierSprite = BarrierSprite(zoneLevel: self)
        self.gateSprite = GateSprite(zoneLevel: self)

        self.addChild(barrierSprite)
        self.addChild(gateSprite)

        self.position = Constants.center
        barrierSprite.position = CGPoint.zero
        gateSprite.position = CGPoint.zero
        gameModel.clockwise = !clockwise
        removeAllActions()
        zRotation = from.zRotation

        run(action)
        gameModel.scene.addChild(self)
        from.removeFromParent()
    }

    func shrink() {
        level -= 1

        if level <= 0 {
            fadeOut()
        } else {
            gateSprite.shrink()
            barrierSprite.shrink()
        }
    }

    func fadeOut() {
        // only add a new top level if the current level is bigger than 4 and if the next level is
        if gameModel.scoreLabel.score > 4 && GameModel.nextLevel >= 5 {
            gameModel.addTopLevel()
        }

        let length = (((Constants.xScaledIncrease * CGFloat(level)) + Constants.scaledRadius) - Constants.xScaledIncrease) * 2
        let fadeOut = SKAction.group([SKAction.fadeOut(withDuration: 0.1625), SKAction.resize(toWidth: length, height: length, duration: 0.1625)])
        let remove = SKAction.run {
            self.removeFromParent()
        }

        self.run(SKAction.sequence([fadeOut, remove]))

    }

    func animate() {
        removeAllActions()

        let random = SKAction.randomRotationAnimation(clockwise: gameModel.clockwise)

        clockwise = gameModel.clockwise
        gameModel.clockwise = !gameModel.clockwise
        time = random.time
        action = SKAction.repeatForever(random.action)
        zRotation = random.rotation
        run(random.action)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GateSprite: SKSpriteNode {

    let gate: Gate
    let zoneLevel: SpinZoneLevel

    init(zoneLevel: SpinZoneLevel) {
        self.zoneLevel = zoneLevel
        self.gate = SpinZoneManager.manager.gates[zoneLevel.level]!

        super.init(texture: gate.texture, color: UIColor.white, size: gate.texture.size())
    }

    func shrink() {
        if zoneLevel.level <= 0 {
            return
        }

        let smallArc = SpinZoneManager.manager.gates[zoneLevel.level]!
        let bigArc = SpinZoneManager.manager.gates[zoneLevel.level + 1]!
        let scale = smallArc.texture.size().height / bigArc.texture.size().height
        let shape = bigArc.shape.copy() as! SKShapeNode

        shape.alpha = 0.15 // TODO: is this needed?

        texture = nil
        shape.zRotation = self.zRotation
        shape.position = self.position

        shape.run(zoneLevel.action)
        zoneLevel.gameModel.scene.addChild(shape)

        run(SKAction.shrink(by: scale) {
            self.removeFromParent()
            shape.removeFromParent()
        })
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BarrierSprite: SKSpriteNode {

    static var barriers = [Int: Barrier]()

    let barrier: Barrier
    let zoneLevel: SpinZoneLevel

    init(zoneLevel: SpinZoneLevel) {
        self.zoneLevel = zoneLevel
        self.barrier = SpinZoneManager.manager.barriers[zoneLevel.level]!

        super.init(texture: barrier.texture, color: UIColor.white, size: barrier.texture.size())
    }

    func shrink() {
        if zoneLevel.level <= 0 {
            return
        }

        let smallArc = SpinZoneManager.manager.barriers[zoneLevel.level]!
        let bigArc = SpinZoneManager.manager.barriers[zoneLevel.level + 1]!
        let scale = smallArc.texture.size().height / bigArc.texture.size().height
        let shape = bigArc.shape.copy() as! SKShapeNode

        texture = nil
        shape.zRotation = self.zRotation
        shape.position = self.position

        shape.run(zoneLevel.action)

        zoneLevel.gameModel.scene.addChild(shape)

        run(SKAction.shrink(by: scale) {
            self.removeFromParent()
            shape.removeFromParent()

            SpinZoneLevel(from: self.zoneLevel)
        })
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
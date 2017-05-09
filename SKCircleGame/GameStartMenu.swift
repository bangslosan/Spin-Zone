//
//  GameStartMenu.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/18/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit
import GameKit

class GameStartMenu: ClickableScene {
    
    override func didMove(to view: SKView) {
        if (TransitionHandler.previousScene == self) {
            return
        }
        
        self.backgroundColor = DynamicBackground.currentColor
        self.transitionHandler = TransitionHandler(buttons: [
            "play": (scene: .game, direction: .left),
            "?": (scene: .about, direction: .down)])
        
        self.sceneTitle(name: "Spin Zone", splitter: " ")
        
        addButtons()
        addFloatingParticles()
    }
    
    func addButtons() {
        let playCrop = SKCropNode()
        
        
        let play = ButtonSprite(title: "Play", under: nil)
        self.addChild(play)
        self.addChild(play.label)
        
        playCrop.maskNode = play
        crops.append(playCrop)
        self.addChild(playCrop)
        
        let leaderboard = ButtonSprite(title: "Leaderboard", under: play)
        leaderboard.runOnClick = {
            SpinZoneManager.manager.showLeaderboards()
        }
        self.addChild(leaderboard)
        self.addChild(leaderboard.label)
        
        let share = ButtonSprite(title: "Share", under: leaderboard)
        share.runOnClick = {
            SpinZoneManager.manager.sendScores()
        }
        self.addChild(share)
        self.addChild(share.label)
        
        let rate = ButtonSprite(title: "Rate", under: share)
        rate.runOnClick = {
            SpinZoneManager.manager.link()
        }
        self.addChild(rate)
        self.addChild(rate.label)
        
        let specialScore = SpecialScore()
        specialScore.background.position = CGPoint(x: Constants.center.x, y: Constants.center.y + 140.yScaled)
        self.addChild(specialScore.background)
        self.addChild(specialScore.score)
        self.addChild(specialScore.levelTitle)
        
        self.addChild(ButtonSprite(bottomLeftTitle: "?"))
    }
}

class SpecialScore {
    
    lazy var background: SKSpriteNode = {
        let circle = SKShapeNode(circleOfRadius: 80.xScaled)
        circle.alpha = 0.30
        circle.fillColor = UIColor.white
        circle.strokeColor = UIColor.white.darkerColor(percent: 10)
        circle.lineWidth = 3
        circle.zPosition = 4
        return SKSpriteNode(texture: SKView().texture(from: circle))
        
    }()
    
    lazy var score: SKLabelNode = {
        let label = SKLabelNode(title: String(GameModel.currentLevel), fontSize: 70.xScaled)
        label.position = CGPoint(x: self.background.position.x, y: self.background.position.y - 15.yScaled)
        label.alpha = 0.85
        label.zPosition = 5
        return label
    }()
    
    lazy var levelTitle: SKLabelNode = {
        let label = SKLabelNode(title: "Level", fontSize: 40.xScaled)
        label.position = CGPoint(x: self.background.position.x, y: self.background.position.y + 25.yScaled)
        label.zPosition = 6
        label.alpha = 0.60
        return label
    }()

}

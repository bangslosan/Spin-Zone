//
//  GameLoseScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 1/1/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class GameLoseScene: ClickableScene {
    
    override func didMove(to view: SKView) {
        if (TransitionHandler.previousScene == self) {
            return
        }
        
        self.transitionHandler = TransitionHandler(buttons:[
             "try again": (scene: .game, direction: .up),
             "menu": (scene: .start, direction: .right)])
        self.sceneTitle(name: "Game Over", splitter: " ")
        
        addButtons()
        addFloatingParticles()
    }
    
    func addButtons() {
        let tryAgain = ButtonSprite(title: "Try Again", under: nil)
        self.addChild(tryAgain)
        self.addChild(tryAgain.label)
        
        let leaderboard = ButtonSprite(title: "Leaderboard", under: tryAgain)
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
        
        let mainMenu = ButtonSprite(title: "Menu", under: share)
        self.addChild(mainMenu)
        self.addChild(mainMenu.label)
        
        let specialScore = SpecialScore()
        specialScore.background.position = CGPoint(x: Constants.center.x, y: Constants.center.y + 140.yScaled)
        self.addChild(specialScore.background)
        self.addChild(specialScore.score)
        self.addChild(specialScore.levelTitle)
    }
    
}

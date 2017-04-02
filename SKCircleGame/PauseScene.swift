//
//  PauseScene.swift
//  Spin Zone
//
//  Created by Nicholas Grana on 3/1/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class PauseScene: ClickableScene {
    
    override func didMove(to view: SKView) {
        if (TransitionHandler.previousScene == self) {
            return
        }
        
        self.transitionHandler = TransitionHandler(buttons: [
            "resume": (scene: .dynamic, direction: .down),
            "quit": (scene: .start, direction: .right)
            ])

        self.sceneTitle(name: "Paused")
        
        self.createButtons()
    }
    
    func createButtons() {
        let help = ButtonSprite(bottomLeftTitle: "?")
        self.addChild(help)
        
        let resume = ButtonSprite(title: "Resume", under: nil)
        self.addChild(resume)
        self.addChild(resume.label)
        
        let leaderboard = ButtonSprite(title: "Leaderboard", under: resume)
        leaderboard.runOnClick = {
            GameViewController.mainView.showLeaderboards()
        }
        self.addChild(leaderboard)
        self.addChild(leaderboard.label)
        
        let share = ButtonSprite(title: "Share", under: leaderboard)
        share.runOnClick = {
            GameViewController.mainView.sendScores()
        }
        self.addChild(share)
        self.addChild(share.label)
        
        let quit = ButtonSprite(title: "Quit", under: share)
        self.addChild(quit)
        self.addChild(quit.label)
        
        let specialScore = SpecialScore()
        specialScore.background.position = CGPoint(x: Constants.center.x, y: Constants.center.y + 140.yScaled)
        self.addChild(specialScore.background)
        self.addChild(specialScore.score)
        self.addChild(specialScore.levelTitle)
    }
    
}

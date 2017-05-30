//
//  GameModel.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 11/21/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit
import GameKit

class GameModel {
    
    static var nextLevel: Int {
        let fromConfig = UserDefaults.standard.integer(forKey: "score")
        return (fromConfig == 0 ? 1 : fromConfig) + 1
    }
    
    static var currentLevel: Int {
        return nextLevel - 1
    }
    
    static var retries: Int {
        // let fromConfig = UserDefaults.standard.integer(forKey: "retries")
        return 1
    }
    
    var clockwise = true
    lazy var scoreLabel: ScoreLabel = ScoreLabel(scene: self.scene)
    let scene: GameScene!
    
    init(scene: GameScene, level: Int) {
        self.scene = scene
        self.scoreLabel.score = level
    }

    func addTopLevel() {
        let spinZoneLevel = SpinZoneLevel(level: 6, model: self)
        scene.addChild(spinZoneLevel)

        spinZoneLevel.shrink()
    }
    
    func updateScore() {
        scoreLabel.score -= 1
        
        if scoreLabel.score == 0 {
            win()
        }
    }
    
    func win() {
        let score = GKScore(leaderboardIdentifier: "spinzone.levels", player: GKLocalPlayer.localPlayer())
        score.value = Int64(GameModel.nextLevel)
        GKScore.report([score], withCompletionHandler: { error in })
        
        // store the current score before next scene loads
        UserDefaults.standard.set(GameModel.nextLevel, forKey: "score")
        
        presentNextScene()
        
        /*
        if (true) {
            earnRetry()
        } else {
            presentNextScene()
        }*/
    }
    
    func presentNextScene() {
        let transition = SKTransition.push(with: .left, duration: 0.5)
        transition.pausesOutgoingScene = true
        transition.pausesIncomingScene = true
        
        let nextScene = GameScene(size: Constants.currentSize)
        nextScene.scaleMode = .aspectFill
        nextScene.backgroundColor = self.scene.backgroundColor
        self.scene.view?.presentScene(nextScene, transition: transition)
    }
    
    func earnRetry() {
        if (true/*GameModel.nextLevel % 10 == 1*/) { // 11, 21, etc, give a new retry
            let alert = UIAlertController(title: "1 Rety", message: "Congradulations! You have earned 1 Rety, earn one every 10 Levels", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: { alert in
                UserDefaults.standard.set(GameModel.retries + 1, forKey: "retries")
            })
            
            alert.addAction(action)
            alert.present((self.scene.view!.window!.rootViewController)!, animated: true, completion: {
                self.presentNextScene()
            })
        }
    }
    
    func lose() {
        let transition = SKTransition.push(with: .down, duration: 0.5)
        transition.pausesOutgoingScene = false
        transition.pausesIncomingScene = false

        let nextScene = GameLoseScene(size: Constants.currentSize)
        nextScene.backgroundColor = self.scene.backgroundColor
        self.scene.view?.presentScene(nextScene, transition: transition)
    }
}

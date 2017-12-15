//
//  GameScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 10/10/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class GameScene: PlayableClickScene, SKPhysicsContactDelegate {

	var gameModel: GameModel!
	var gameView: GameView!
	var scoreLabel: SKLabelNode!
	var themeColor: UIColor!

	var score: Int {
		get {
			return Int(scoreLabel.text!)!
		}
		set {
			scoreLabel.text = String(newValue)
		}
	}

	override func didMove(to view: SKView) {
		if (TransitionHandler.previousScene == self) {
			return
		}

		gameScene = self
		physicsWorld.contactDelegate = self

		let level = GameModel.currentLevel

		gameModel = GameModel(scene: self, level: level)
		gameView = GameView(level: level, model: gameModel)

	}

	// used to block touches while the physics is being applied
	var allowTouchBegan = true

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event) // for ability to press pause button

		if !allowTouchBegan || (super.prevSelected != nil && super.selected != nil) { // must be allowed to touch (no physics) and not already touching a pause button
			return
		}

		for node in gameModel.scene.children {
			if let spinZoneLevel = node as? SpinZoneLevel {
                spinZoneLevel.shrink()
			}
		}

		let seconds = 0.1725

		allowTouchBegan = false

		DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
			self.touchable = true
			self.gameView.applyBarrierPhysics()
			self.allowTouchBegan = true
		})
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds + 0.05, execute: {
			self.gameView.applyGatePhysics()
		})
	}

	// used to block all contacts so it runs only once
	var touchable = true
	func didBegin(_ contact: SKPhysicsContact) {
		if !touchable {
			return
		}

		let touched = contact.bodyA

		if touched.categoryBitMask == Catigory.goal.rawValue {
			gameModel.updateScore()
		} else if touched.categoryBitMask == Catigory.track.rawValue {
			gameModel.lose()
		}

		touchable = false
	}
}

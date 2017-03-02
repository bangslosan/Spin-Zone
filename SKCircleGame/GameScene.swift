//
//  GameScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 10/10/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class GameScene: ClickableScene, SKPhysicsContactDelegate {

	var gameModel: GameModel!
	
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
		self.model = MenuModel()
		
		self.physicsWorld.contactDelegate = self
		
		let level = GameModel.currentLevel
		
		self.gameModel = GameModel(scene: self, level: level)
		
		self.gameModel.createTracks()
		self.addChild(ButtonSprite(bottomLeftTitle: "||"))
	}
	
	// used to block touches while the physics is being applied
	var allowTouchBegan = true
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event) // for ability to press pause button
		
		if !allowTouchBegan {
			return
		}
		
		for node in gameModel.scene.children {
			if let track = node as? TrackSprite {
				track.shrink()
			}
		}
		
		let seconds = 0.1725
		
		allowTouchBegan = false
		
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
			self.touchable = true
			self.gameModel.applyTrackPhysics()
			self.allowTouchBegan = true
		})
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds + 0.05, execute: {
			self.gameModel.applyGoalPhysics()
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
			gameModel.audio.playPing()
		} else if touched.categoryBitMask == Catigory.track.rawValue {
			gameModel.lose()
			gameModel.audio.playPing()
		}
		
		touchable = false
	}
}

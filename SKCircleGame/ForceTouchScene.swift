//
//  ForceTouchScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/18/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class ForceTouchScene: SKScene {
   
    // MARK: Properties

    var circle: SKSpriteNode!
    
    var stop = false
    var timer: Timer? = nil

    var currentTouchPosition = CGPoint.zero
    
    var maxSize: CGFloat {
        return max(max(Constants.topLeft.distance(between: circle.position), Constants.topRight.distance(between: circle.position)), max(Constants.bottomLeft.distance(between: circle.position), Constants.bottomRight.distance(between: circle.position))) + 5
    }
    
    // from 0.0 to 1.0 for time & 3D touch to work on different devices
    var circleSize: CGFloat = 0.0 {
        didSet {
            guard let circle = circle else {
                return
            }
            
            let size = (circleSize * maxSize) * 2
            circle.size = CGSize(width: size, height: size)
            
            if (circleSize >= 1.0) {
                SpinZoneManager.themes.updateColors()
            }
        }
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        syncBackground()
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        SpinZoneManager.themes.updateScenes.append(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ForceTouchScene.removeCircle), name: NSNotification.Name(rawValue: "RemoveCircle"), object: nil)
    }
    
    // MARK: Circle Functions
    
    func createCircle() -> SKSpriteNode {
        let circle = SKShapeNode(circleOfRadius: self.size.height)
        circle.strokeColor = SpinZoneManager.themes.nextColor
        circle.fillColor = SpinZoneManager.themes.nextColor
        let sprite = SKSpriteNode(texture: SKView().texture(from: circle)!)
        sprite.zPosition = -1
        sprite.size = CGSize.zero
        return sprite
    }
    
    func transitionBackground() {
        stop = true

        removeCircle()
        self.circle = self.createCircle()
                
        syncBackground()
    }
    
    func syncBackground() {
        backgroundColor = SpinZoneManager.themes.currentColor
        
        // change the fonts
        for node in children {
            if let label = node as? SKLabelNode, label.alpha == 1.0 { // only buttons have an alpha of 1.0
                label.fontColor = backgroundColor
            }
        }
    }
    
    @objc func removeCircle() {
        self.circleSize = 0.0
        self.circle?.removeFromParent()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func update(size: CGFloat) {
        if !stop {
            circleSize = size
            circle?.position = currentTouchPosition
        }
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { t in
                self.update(size: self.circleSize + 0.002)
            })
        }
    }
    
    // MARK: Action events

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            currentTouchPosition = touch.location(in: self)
            
            if circle == nil {
                circle = createCircle()
            }
            
            if circle.scene == nil && !stop {
                circle.position = currentTouchPosition
                addChild(circle)
            }
            
            if #available(iOS 9.0, *) {
                if let view = self.view, view.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                    update(size: CGFloat(touch.force / touch.maximumPossibleForce))
                } else {
                    startTimer()
                }
            } else {
                startTimer()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeCircle()
        stop = false
    }
    
    
}

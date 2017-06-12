//
//  GameViewController.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 10/10/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    // MARK: Overriden methods
    
    // constraints, uikit + spritekit, tvOS
    var gameStartMenu: GameStartMenu! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let manager = SpinZoneManager.manager

        manager.authPlayer()
        manager.mainView = self
        Constants.currentSize = self.view.frame.size

        if let newView = view as? SKView {
            gameStartMenu = GameStartMenu(size: Constants.currentSize)

            manager.loadBarriers()
            manager.loadGates()

            gameStartMenu.scaleMode = .aspectFill
            newView.presentScene(self.gameStartMenu)
            newView.ignoresSiblingOrder = true
        }
        
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        self.dismiss(animated: true, completion: {})
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

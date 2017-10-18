//
//  ViewController.swift
//  The Spin Zone
//
//  Created by Nicholas Grana on 10/17/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit
import GameKit

class StartMenuViewController: UIViewController, GKGameCenterControllerDelegate {

    var game: GameManager!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // connect to game center
        authPlayer()
        
        // game manager that will be shared through segues througout application life
        game = GameManager(size: view.frame.size)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func authPlayer() {
        let local = GKLocalPlayer.localPlayer()
        
        local.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                // present(view!, animated: true, completion: {})
            }
        }
        
    }
    
    @IBAction func clickLeaderboard(_ sender: UIButton) {
        let leaderboardViewController = GKGameCenterViewController()
        leaderboardViewController.viewState = .leaderboards
        leaderboardViewController.leaderboardTimeScope = .today
        leaderboardViewController.leaderboardIdentifier = "spinzone.levels"
        leaderboardViewController.gameCenterDelegate = self
        self.present(leaderboardViewController, animated: true, completion: {})
    }
    
    @IBAction func clickShare(_ sender: UIButton) {
        let shareViewController = UIActivityViewController(activityItems: ["I'm on level \(game.levels.current) in Spin Zone! Check it out, it's free: https://itunes.apple.com/app/id1200316153"], applicationActivities: nil)
        present(shareViewController, animated: true, completion: {})
    }
    
    @IBAction func clickRate(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://itunes.apple.com/app/id1200316153")!)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        self.dismiss(animated: true, completion: {})
    }
}

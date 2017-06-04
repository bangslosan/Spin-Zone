//
//  SpinZoneManager.swift
//  Spin Zone
//
//  Created by Nicholas Grana on 5/3/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit
import GameKit

class SpinZoneManager {

    static let manager = SpinZoneManager()
    static let themes = ThemeManager()
    
    var barriers = [Int: Barrier]()
    var gates = [Int: Gate]()
    var mainView: GameViewController!

    init() {

    }

    func loadBarriers() {
        for level in 1...6 {
            barriers[level] = Barrier(level: level)
        }
    }

    func loadGates() {
        for level in 1...6 {
            gates[level] = Gate(level: level)
        }
    }

    func authPlayer() {
        let local = GKLocalPlayer.localPlayer()

        local.authenticateHandler = {
            (view, error) in

            if view != nil {
                self.mainView.present(view!, animated: true, completion: {})
            }
        }

    }

    func showLeaderboards() {
        let leaderboardViewController = GKGameCenterViewController()
        leaderboardViewController.viewState = .leaderboards
        leaderboardViewController.leaderboardTimeScope = .today
        leaderboardViewController.leaderboardIdentifier = "spinzone.levels"
        leaderboardViewController.gameCenterDelegate = mainView
        mainView.present(leaderboardViewController, animated: true, completion: {})
    }

    func sendScores() {
        let shareViewController = UIActivityViewController(activityItems: ["I'm on level \(GameModel.currentLevel) in Spin Zone! Check it out, it's free: https://itunes.apple.com/app/id1200316153"], applicationActivities: nil)
        mainView.present(shareViewController, animated: true, completion: {})
    }

    func link() {
        UIApplication.shared.open(URL(string: "https://itunes.apple.com/app/id1200316153")!)
    }


}

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

    var barriers = [Int: Barrier]()
    var gates = [Int: Gate]()
    var mainView: GameViewController!

    var theme = UIColor.grayThemeBackground

    let themes = [
            UIColor.grayThemeBackground,
            UIColor.redThemeBackground,
            UIColor.orangeThemeBackground,
            UIColor.yellowThemeBackground,
            UIColor.greenThemeBackground,
            UIColor.blueThemeBackground,
            UIColor.purpleThemeBackground,
            UIColor.pinkThemeBackground
    ]

    var currentIndex: Int {
        get {
            return UserDefaults.standard.integer(forKey: "color-index")
        }
        set {
            let v = newValue
            UserDefaults.standard.set(v + 1 > themes.count - 1 ? 0 : v + 1, forKey: "color-index")
            currentIndex = v
        }

    }

    var colorActions: [SKAction] {
        return themes.map {
            return SKAction.sequence([SKAction.run{ self.currentIndex += 1 }, SKAction.colorize(with: $0, colorBlendFactor: 1.0, duration: 15.0), ])
        }
    }

    var currentColor: UIColor {
        theme = themes[currentIndex]
        return themes[currentIndex]
    }

    var nextColor: UIColor {
        return themes[nextIndex]
    }

    var nextIndex: Int {
        return currentIndex + 1 > themes.count - 1 ? 0 : currentIndex + 1
    }

    var ballNextIndex: Int {
        return nextIndex + 1 > themes.count - 1 ? 0 : nextIndex + 1
    }

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
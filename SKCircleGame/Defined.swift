//
//  Defined.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/19/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

struct Constants {
    
    static let topLeft = CGPoint.zero
    static let topRight = CGPoint(x: baseSize.width, y: 0)
    static let bottomLeft = CGPoint(x: 0, y: baseSize.height)
    static let bottomRight = CGPoint(x: baseSize.width, y: baseSize.height)
    
    static var xScale = currentSize.width / baseSize.width
    static var yScale = currentSize.height / baseSize.height
    static let baseSize = CGSize(width: 375, height: 667)
    static var currentSize: CGSize! = nil
    
    static let sceneTitlePosition = CGPoint(x: currentSize.width / 2, y: currentSize.height - 60.yScaled)
    
    static var center = CGPoint(x: currentSize.width / 2, y: currentSize.height / 2)
    
    static var scaledRadius = 50.xScaled
    static var xScaledIncrease = 25.xScaled
    static var lineWidth = 9.xScaled // 10.xScaled
    static var ballRadius = 20.xScaled
    static var smallButtonRadius = 20.xScaled // help button & pause button background
    
    static var angle = -60 // arc angle for each spinning circle & track
    
    static var titleFont = 80.xScaled
    static var buttonFont = 30.xScaled
}

enum Catigory: UInt32 {
    
    case track = 0
    case goal = 1
    case ball = 2
    
}

enum Contact: UInt32 {
    
    case track = 0
    case goal = 1
    case ball = 2
    
}

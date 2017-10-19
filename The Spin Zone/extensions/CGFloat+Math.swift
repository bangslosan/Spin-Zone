//
//  CGFloat+Math.swift
//  The Spin Zone
//
//  Created by Nicholas Grana on 10/18/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import UIKit

extension CGFloat {
    
    static func radian(fromDegree degree: Int) -> CGFloat {
        return CGFloat((Double.pi / 180)) * CGFloat(degree)
    }
    
}

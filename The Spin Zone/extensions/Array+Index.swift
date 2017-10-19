//
//  Array+Index.swift
//  The Spin Zone
//
//  Created by Nicholas Grana on 10/18/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import Foundation

extension Array {
    
    func nextIndex(at index: Int) -> Int {
        if index >= count {
            return 0
        }
        return index
    }
    
    func nextIndexElement(at index: Int) -> Element {
        return self[nextIndex(at: index)]
    }
    
}

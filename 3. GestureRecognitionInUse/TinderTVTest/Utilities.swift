//
//  Utilities.swift
//  TinderTVTest
//
//  Created by Saniul Ahmed on 06/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import Foundation
import QuartzCore

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

func +(a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPointMake(a.x + b.x, a.y + b.y)
}

func -(a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPointMake(a.x - b.x, a.y - b.y)
}

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * (CGFloat(M_PI)/180.0)
    }
}
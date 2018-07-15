//
//  CGPointExtensions.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/15/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    /// Calculates the distance between two points in 2D space.
    /// + returns: The distance from this point to the given point.
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
    
}

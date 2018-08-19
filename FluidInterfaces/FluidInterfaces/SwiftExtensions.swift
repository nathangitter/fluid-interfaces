//
//  SwiftExtensions.swift
//  FluidInterfaces
//
//  Created by Maksym Shcheglov on 19/08/2018.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

#if swift(>=4.2)
#else
public extension UIScrollView {
    enum DecelerationRate: CGFloat {
        case normal = 0.998
        case fast = 0.99
    }
}

public extension Bool {
    mutating func toggle() {
        self = !self
    }
}
#endif

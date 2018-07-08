//
//  MenuViewController.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/7/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        
    }

}

class InterfaceCell: UICollectionViewCell {
    
    //
    
}

///// Distance traveled after decelerating to zero velocity at a constant rate.
//func project(initialVelocity: Float, decelerationRate: Float) -> Float {
//    return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
//}

// After the PiP is thrown, determine the best corner and re-target it there.
// (put this is pan gesture ended)

//let decelerationRate = UIScrollView.DecelerationRate.normal
//
//let projectedPosition = (
//    x: x.value + project(initialVelocity: x.velocity, decelerationRate: decelerationRate)
//    y: y.value + project(initialVelocity: y.velocity, decelerationRate: decelerationRate),
//)
//
//let nearestCornerPosition = nearestCornerTo(projectedPosition)
//
//x.target = nearestCornerPosition.x
//y.traget = nearestCornerPosition.y

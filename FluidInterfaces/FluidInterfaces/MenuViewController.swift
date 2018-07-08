//
//  MenuViewController.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/7/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    private let interfaces: [Interface] = [
        Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "iconCalc")),
        Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "iconCalc")),
        Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "iconCalc")),
        Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "iconCalc")),
        Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "iconCalc")),
    ]
    
    @IBOutlet private weak var collectionView: UICollectionView!

}

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
    
}

extension MenuViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interfaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterfaceCell.identifier, for: indexPath) as? InterfaceCell else { return UICollectionViewCell() }
        let interface = interfaces[indexPath.item]
        cell.title = interface.name
        cell.image = interface.icon
        return cell
    }
    
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
}

struct Interface {
    var name: String
    var icon: UIImage
}

class InterfaceCell: UICollectionViewCell {
    
    public static let identifier = "interfaceCell"
    
    public var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var image = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
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

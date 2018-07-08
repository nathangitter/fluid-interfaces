//
//  Interface.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/8/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

struct Interface {
    var name: String
    var icon: UIImage
    var type: InterfaceViewController.Type
}

extension Interface {
    
    public static var all: [Interface] {
        return [
            Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "iconCalc"), type: CalculatorButtonInterfaceViewController.self),
            Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "iconCalc"), type: CalculatorButtonInterfaceViewController.self),
            Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "iconCalc"), type: CalculatorButtonInterfaceViewController.self),
            Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "iconCalc"), type: CalculatorButtonInterfaceViewController.self),
            Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "iconCalc"), type: CalculatorButtonInterfaceViewController.self),
        ]
    }
    
}

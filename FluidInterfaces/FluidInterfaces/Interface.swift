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
            Interface(name: "Spring animations", icon: #imageLiteral(resourceName: "icon_spring"), type: SpringInterfaceViewController.self),
            Interface(name: "Rubberbanding", icon: #imageLiteral(resourceName: "icon_rubber"), type: RubberbandingInterfaceViewController.self),
            Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "icon_calc"), type: CalculatorButtonInterfaceViewController.self),
            Interface(name: "Acceleration pausing", icon: #imageLiteral(resourceName: "icon_acceleration"), type: AccelerationInterfaceViewController.self),
            Interface(name: "Flashlight button", icon: #imageLiteral(resourceName: "icon_flash"), type: FlashlightButtonInterfaceViewController.self),
            Interface(name: "Rewarding momentum", icon: #imageLiteral(resourceName: "icon_momentum"), type: MomentumInterfaceViewController.self),
            Interface(name: "FaceTime PiP", icon: #imageLiteral(resourceName: "icon_pip"), type: PipInterfaceViewController.self),
            Interface(name: "Scaling and rotation", icon: #imageLiteral(resourceName: "icon_rotation"), type: RotationInterfaceViewController.self),
            Interface(name: "Springboard", icon: #imageLiteral(resourceName: "icon_springboard"), type: SpringboardInterfaceViewController.self),
        ]
    }
    
}

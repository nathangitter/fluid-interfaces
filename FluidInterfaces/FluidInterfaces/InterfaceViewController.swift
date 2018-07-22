//
//  InterfaceViewController.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/8/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

/// Base class for all interface view controllers.
class InterfaceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.05, alpha: 1) // reduces screen tearing on iPhone X
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
}

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
        
        view.backgroundColor = .black
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
}

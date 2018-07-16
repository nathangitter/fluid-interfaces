//
//  Acceleration.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/8/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

class AccelerationInterfaceViewController: InterfaceViewController {
    
    private lazy var accelerationView: GradientView = {
        let view = GradientView()
        view.topColor = UIColor(hex: 0x64FF8F)
        view.bottomColor = UIColor(hex: 0x51FFEA)
        return view
    }()
    
    private let panRecognizer = UIPanGestureRecognizer()
    
    private let verticalOffset: CGFloat = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(accelerationView)
        // todo center in safe area? / make sure this works on different device sizes
        accelerationView.center(in: view, offset: UIOffset(horizontal: 0, vertical: verticalOffset))
        accelerationView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        accelerationView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        panRecognizer.addTarget(self, action: #selector(panned))
        accelerationView.addGestureRecognizer(panRecognizer)
        
    }
    
    private var originalTouchPoint: CGPoint = .zero
    
    @objc private func panned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        switch recognizer.state {
        case .began:
            originalTouchPoint = touchPoint
        case .changed:
            let offset: CGFloat = {
                let offset = touchPoint.y - originalTouchPoint.y
                if offset > 0 {
                    return pow(offset, 0.7)
                } else if offset < -verticalOffset * 2 {
                    return -verticalOffset * 2 - pow(-(offset + verticalOffset * 2), 0.7)
                }
                return offset
            }()
            accelerationView.transform = CGAffineTransform(translationX: 0, y: offset)
        case .ended, .cancelled:
            let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.6, animations: {
                self.accelerationView.transform = .identity
            })
            animator.isInterruptible = true
            animator.startAnimation()
        default: break
        }
    }
    
}

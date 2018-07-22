//
//  Rubberbanding.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/8/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

class RubberbandingInterfaceViewController: InterfaceViewController {
    
    private lazy var rubberView: GradientView = {
        let view = GradientView()
        view.topColor = UIColor(hex: 0xFF5B50)
        view.bottomColor = UIColor(hex: 0xFFC950)
        return view
    }()
    
    private let panRecognier = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(rubberView)
        rubberView.center(in: view)
        rubberView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        rubberView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        panRecognier.addTarget(self, action: #selector(panned(recognizer:)))
        rubberView.addGestureRecognizer(panRecognier)
        
    }
    
    private var originalTouchPoint: CGPoint = .zero
    
    @objc private func panned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        switch recognizer.state {
        case .began:
            originalTouchPoint = touchPoint
        case .changed:
            var offset = touchPoint.y - originalTouchPoint.y
            offset = offset > 0 ? pow(offset, 0.7) : -pow(-offset, 0.7)
            rubberView.transform = CGAffineTransform(translationX: 0, y: offset)
        case .ended, .cancelled:
            let timingParameters = UISpringTimingParameters(damping: 0.6, response: 0.3)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.rubberView.transform = .identity
            }
            animator.isInterruptible = true
            animator.startAnimation()
        default: break
        }
    }
    
}

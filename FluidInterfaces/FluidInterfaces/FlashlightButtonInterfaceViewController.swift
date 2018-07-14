//
//  FlashlightButtonInterfaceViewController.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/8/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

class FlashlightButtonInterfaceViewController: InterfaceViewController {
    
    private let flashlightButton = FlashlightButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(flashlightButton)
        flashlightButton.center(in: view)
        
    }
    
}

class FlashlightButton: UIControl {
    
    private enum ForceState {
        
        /// The button is ready to be activiated. Default state.
        case reset
        
        /// The button has been pressed with enough force.
        case activated
        
        /// The button has recently switched on/off.
        case confirmed
        
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        //
        return imageView
    }()
    
    private var isOn: Bool = false
    private var forceState: ForceState = .reset
    
    private let activationFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let confirmationFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private let minWidth: CGFloat = 50
    private let maxWidth: CGFloat = 92
    
    private let offAlpha: CGFloat = 0.3
    private let onAlpha: CGFloat = 0.9
    
    private let activationForce: CGFloat = 0.6
    private let confirmationForce: CGFloat = 0.58
    private let resetForce: CGFloat = 0.2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        
        backgroundColor = .white
        alpha = offAlpha
        
        addSubview(imageView)
        imageView.center(in: self)
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: minWidth, height: minWidth)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        //
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let firstTouch = touches.first else { return }
        
        let force = firstTouch.force / firstTouch.maximumPossibleForce
        let scale = 1 + (maxWidth / minWidth - 1) * force
        
        transform = CGAffineTransform(scaleX: scale, y: scale)
        
        switch forceState {
        case .reset:
            if force >= activationForce {
                forceState = .activated
                activationFeedbackGenerator.impactOccurred()
            }
        case .activated:
            if force <= confirmationForce {
                forceState = .confirmed
                // change image here
                isOn.toggle()
                alpha = isOn ? onAlpha : offAlpha
                confirmationFeedbackGenerator.impactOccurred()
            }
        case .confirmed:
            ()
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchesEnded(touch: touches.first)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchesEnded(touch: touches.first)
    }
    
    private func touchesEnded(touch: UITouch?) {
        forceState = .reset
        animateToRest()
    }
    
    private func animateToRest() {
        // todo animate this with a little springiness
        transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
}

//
//  Pip.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/8/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

class PipInterfaceViewController: InterfaceViewController {
    
    private lazy var pipView: GradientView = {
        let view = GradientView()
        view.topColor = UIColor(hex: 0xF2F23A)
        view.bottomColor = UIColor(hex: 0xF7A51C)
        view.cornerRadius = 16
        return view
    }()
    
    private var pipPositionViews = [PipPositionView]()
    
    private let panRecognizer = UIPanGestureRecognizer()
    
    private var pipPositions: [CGPoint] {
        return pipPositionViews.map { $0.center }
    }
    
    private let pipWidth: CGFloat = 86
    private let pipHeight: CGFloat = 130
    
    private let horizontalSpacing: CGFloat = 23
    private let verticalSpacing: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topLeftView = addPipPositionView()
        topLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing).isActive = true
        topLeftView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing).isActive = true
        
        let topRightView = addPipPositionView()
        topRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing).isActive = true
        topRightView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing).isActive = true
        
        let bottomLeftView = addPipPositionView()
        bottomLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing).isActive = true
        bottomLeftView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalSpacing).isActive = true
        
        let bottomRightView = addPipPositionView()
        bottomRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing).isActive = true
        bottomRightView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalSpacing).isActive = true
        
        view.addSubview(pipView)
        pipView.translatesAutoresizingMaskIntoConstraints = false
        pipView.widthAnchor.constraint(equalToConstant: pipWidth).isActive = true
        pipView.heightAnchor.constraint(equalToConstant: pipHeight).isActive = true
        
        panRecognizer.addTarget(self, action: #selector(pipPanned(recognizer:)))
        pipView.addGestureRecognizer(panRecognizer)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pipView.center = pipPositions.last ?? .zero
    }
    
    private func addPipPositionView() -> PipPositionView {
        let view = PipPositionView()
        self.view.addSubview(view)
        pipPositionViews.append(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: pipWidth).isActive = true
        view.heightAnchor.constraint(equalToConstant: pipHeight).isActive = true
        return view
    }
    
    private var initialOffset: CGPoint = .zero
    
    @objc private func pipPanned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        switch recognizer.state {
        case .began:
            initialOffset = CGPoint(x: touchPoint.x - pipView.center.x, y: touchPoint.y - pipView.center.y)
        case .changed:
            pipView.center = CGPoint(x: touchPoint.x - initialOffset.x, y: touchPoint.y - initialOffset.y)
        case .ended, .cancelled:
            let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
            let velocity = recognizer.velocity(in: view)
            let projectedPosition = CGPoint(
                x: pipView.center.x + project(initialVelocity: velocity.x, decelerationRate: decelerationRate),
                y: pipView.center.y + project(initialVelocity: velocity.y, decelerationRate: decelerationRate)
            )
            let nearestCornerPosition = nearestCorner(to: projectedPosition)
            let relativeInitialVelocity = CGVector(
                dx: relativeVelocity(forVelocity: velocity.x, from: pipView.center.x, to: nearestCornerPosition.x),
                dy: relativeVelocity(forVelocity: velocity.y, from: pipView.center.y, to: nearestCornerPosition.y)
            )
            let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4, initialVelocity: relativeInitialVelocity)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.pipView.center = nearestCornerPosition
            }
            animator.startAnimation()
        default: break
        }
    }
    
    /// Distance traveled after decelerating to zero velocity at a constant rate.
    private func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
    }
    
    /// Finds the position of the nearest corner to the given point.
    private func nearestCorner(to point: CGPoint) -> CGPoint {
        var minDistance = CGFloat.greatestFiniteMagnitude
        var closestPosition = CGPoint.zero
        for position in pipPositions {
            let distance = point.distance(to: position)
            if distance < minDistance {
                closestPosition = position
                minDistance = distance
            }
        }
        return closestPosition
    }
    
    /// Calculates the relative velocity needed for the initial velocity of the animation.
    private func relativeVelocity(forVelocity velocity: CGFloat, from currentValue: CGFloat, to targetValue: CGFloat) -> CGFloat {
        guard currentValue - targetValue != 0 else { return 0 }
        return velocity / (targetValue - currentValue)
    }
    
}

class PipPositionView: UIView {
    
    private lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor(white: 0.3, alpha: 1).cgColor
        layer.lineWidth = lineWidth
        return layer
    }()
    
    private let lineWidth: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        shapeLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2), cornerRadius: 16).cgPath
    }
    
}

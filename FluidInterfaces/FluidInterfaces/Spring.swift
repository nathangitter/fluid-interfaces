//
//  Spring.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/8/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

class SpringInterfaceViewController: InterfaceViewController {
    
    private lazy var springView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topColor = UIColor(hex: 0x64CCF7)
        view.bottomColor = UIColor(hex: 0x359EEC)
        return view
    }()
    
    private lazy var dampingSliderView: SliderView = {
        let sliderView = SliderView()
        sliderView.valueFormatter = { String(format: "%i%%", Int($0 * 100)) }
        sliderView.title = "DAMPING"
        sliderView.range = 0.1...1
        sliderView.value = dampingRatio
        sliderView.sliderMovedAction = { self.dampingRatio = $0 }
        sliderView.sliderFinishedMovingAction = { self.resetAnimation() }
        return sliderView
    }()
    
    private lazy var frequencySliderView: SliderView = {
        let sliderView = SliderView()
        sliderView.valueFormatter = { String(format: "%.2fs", $0) }
        sliderView.title = "RESPONSE"
        sliderView.range = 0.1...2
        sliderView.value = frequencyResponse
        sliderView.sliderMovedAction = { self.frequencyResponse = $0 }
        sliderView.sliderFinishedMovingAction = { self.resetAnimation() }
        return sliderView
    }()
    
    private var dampingRatio: CGFloat = 0.5
    private var frequencyResponse: CGFloat = 1
    
    private let margin: CGFloat = 30

    private var leadingAnchor, trailingAnchor : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dampingSliderView)
        UIView.activate(constraints: [
            dampingSliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            dampingSliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            dampingSliderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
        
        view.addSubview(frequencySliderView)
        UIView.activate(constraints: [
            frequencySliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            frequencySliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            frequencySliderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 140)
        ])
        
        view.addSubview(springView)
        UIView.activate(constraints: [
            springView.heightAnchor.constraint(equalToConstant: 80),
            springView.widthAnchor.constraint(equalToConstant: 80),
            springView.bottomAnchor.constraint(equalTo: dampingSliderView.topAnchor, constant: -80)
        ])
        self.leadingAnchor = springView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin)
        self.leadingAnchor.isActive = true
        self.trailingAnchor = springView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin)
        self.trailingAnchor.isActive = false

        animateView()
        
    }
    
    private var animator = UIViewPropertyAnimator()
    
    /// Repeatedly animates the view using the current `dampingRatio` and `frequencyResponse`.
    private func animateView() {
        self.view.layoutIfNeeded()

        let timingParameters = UISpringTimingParameters(damping: dampingRatio, response: frequencyResponse)
        animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
        animator.addAnimations {
            self.leadingAnchor.isActive = !self.leadingAnchor.isActive
            self.trailingAnchor.isActive = !self.trailingAnchor.isActive
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { _ in self.animateView() }
        animator.startAnimation()
    }
    
    private func resetAnimation() {
        animator.stopAnimation(true)
        animateView()
    }
    
}

/// A view that displays a title, value, and slider.
class SliderView: UIView {
    
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var value: CGFloat {
        get {
            return CGFloat(slider.value)
        }
        set {
            slider.value = Float(newValue)
            valueLabel.text = valueFormatter(newValue)
        }
    }
    
    public var range: ClosedRange<Float> = 0...1 {
        didSet {
            slider.minimumValue = range.lowerBound
            slider.maximumValue = range.upperBound
        }
    }
    
    /// Code to format the value to a string for the valueLabel
    public var valueFormatter: (CGFloat) -> (String) = { String(format: "%.2f", $0) }

    /// Code that's executed when the slider moves.
    public var sliderMovedAction: (CGFloat) -> () = { _ in }
    
    /// Code that's executed when the slider has finished moving.
    public var sliderFinishedMovingAction: () -> () = {}
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderMoved(slider:event:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.text = "0"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        
        addSubview(titleLabel)
        UIView.activate(constraints: [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        addSubview(valueLabel)
        UIView.activate(constraints: [
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor)
        ])

        addSubview(slider)
        UIView.activate(constraints: [
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor),
            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        ])

    }
    
    @objc private func sliderMoved(slider: UISlider, event: UIEvent) {
        valueLabel.text = valueFormatter(CGFloat(slider.value))
        sliderMovedAction(CGFloat(slider.value))
        if event.allTouches?.first?.phase == .ended { sliderFinishedMovingAction() }
    }
    
}

extension UISpringTimingParameters {
    
    /// A design-friendly way to create a spring timing curve.
    ///
    /// - Parameters:
    ///   - damping: The 'bounciness' of the animation. Value must be between 0 and 1.
    ///   - response: The 'speed' of the animation.
    ///   - initialVelocity: The vector describing the starting motion of the property. Optional, default is `.zero`.
    public convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
    
}

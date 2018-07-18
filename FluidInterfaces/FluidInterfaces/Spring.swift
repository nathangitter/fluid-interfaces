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
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.title = "DAMPING RATIO"
        sliderView.minValue = 0.1
        sliderView.maxValue = 1.5
        sliderView.value = dampingRatio
        sliderView.sliderMovedAction = { value in
            self.dampingRatio = value
        }
        return sliderView
    }()
    
    private lazy var frequencySliderView: SliderView = {
        let sliderView = SliderView()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.title = "FREQUENCY RESPONSE"
        sliderView.minValue = 0.1
        sliderView.maxValue = 1.5
        sliderView.value = frequencyResponse
        sliderView.sliderMovedAction = { value in
            self.frequencyResponse = value
        }
        return sliderView
    }()
    
    private var dampingRatio: CGFloat = 1
    private var frequencyResponse: CGFloat = 1
    
    private let margin: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dampingSliderView)
        dampingSliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        dampingSliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        dampingSliderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        view.addSubview(frequencySliderView)
        frequencySliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        frequencySliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        frequencySliderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 140).isActive = true
        
        view.addSubview(springView)
        springView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        springView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        springView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        springView.bottomAnchor.constraint(equalTo: dampingSliderView.topAnchor, constant: -80).isActive = true
        
        animateView()
        
    }
    
    /// Repeatedly animates the view using the current `dampingRatio` and `frequencyResponse`.
    private func animateView() {
        let timingParameters = UISpringTimingParameters(dampingRatio: dampingRatio, frequencyResponse: frequencyResponse)
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
        animator.addAnimations {
            let translation = self.view.bounds.width - 2 * self.margin - 80
            self.springView.transform = CGAffineTransform(translationX: translation, y: 0)
        }
        animator.addCompletion { _ in
            self.springView.transform = .identity
            self.animateView()
        }
        animator.startAnimation()
    }
    
}

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
            valueLabel.text = String(format: "%.2f", newValue)
        }
    }
    
    public var minValue: CGFloat = 0 {
        didSet {
            slider.minimumValue = Float(minValue)
        }
    }
    
    public var maxValue: CGFloat = 1 {
        didSet {
            slider.maximumValue = Float(maxValue)
        }
    }
    
    /// Code that's executed when the slider moves.
    public var sliderMovedAction: (CGFloat) -> () = { _ in }
    
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
        slider.addTarget(self, action: #selector(sliderMoved), for: .valueChanged)
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
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(valueLabel)
        valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        valueLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor).isActive = true
        
        addSubview(slider)
        slider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        slider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 80).isActive = true
        slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
    }
    
    @objc private func sliderMoved() {
        valueLabel.text = String(format: "%.2f", slider.value)
        sliderMovedAction(CGFloat(slider.value))
    }
    
}

extension UISpringTimingParameters {
    
    public convenience init(dampingRatio: CGFloat, frequencyResponse: CGFloat) {
        let mass: CGFloat = 1
        let stiffness = pow(2 * .pi / frequencyResponse, 2) * mass
        let damping = 4 * .pi * dampingRatio * mass / frequencyResponse
        self.init(mass: mass, stiffness: stiffness, damping: damping, initialVelocity: .zero)
    }
    
}

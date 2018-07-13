//
//  CalculatorButtonInterfaceViewController.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/8/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

class CalculatorButtonInterfaceViewController: InterfaceViewController {
    
    private lazy var calculatorButton: CalculatorButton = {
        let button = CalculatorButton()
        button.value = 9
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(calculatorButton)
        calculatorButton.center(in: view)
        
    }
    
}

class CalculatorButton: UIControl {
    
    public var value: Int = 0 {
        didSet {
            label.text = "\(value)"
        }
    }
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
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
        backgroundColor = UIColor(hex: 0x333333)
        addSubview(label)
        label.center(in: self)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 75, height: 75)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
}

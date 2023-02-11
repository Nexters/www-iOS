//
//  Stepper.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/11.
//  Copyright © 2023 com.promise8. All rights reserved.
//
// ref : https://github.com/gmertk/GMStepper/blob/master/GMStepper/GMStepper.swift

import UIKit
import SnapKit

struct StepperViewData {
    let color: UIColor
    let minimum: Double = 1
    let maximum: Double = 20
    let stepValue: Double
}

public class Stepper: UIControl {
    
    private lazy var plusButton = stepperButton(color: viewData.color, text: "+", value: 1)
    private lazy var minusButton = stepperButton(color: viewData.color, text: "-", value: -1)
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.www(size: 72, family: .Light)
        label.textAlignment = .center
        label.text = "1"
        return label
    }()
    
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private (set) var value: Double = 0
    private let viewData: StepperViewData
    
    init(viewData: StepperViewData) {
        self.viewData = viewData
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ newValue: Double) {
        updateValue(min(viewData.maximum, max(viewData.minimum, newValue)))
    }
    
    private func setup() {
        backgroundColor = .white
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        [minusButton, counterLabel, plusButton].forEach(container.addArrangedSubview)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        plusButton.layer.cornerRadius = 0.5 * bounds.size.height
        minusButton.layer.cornerRadius = 0.5 * bounds.size.height
    }
    
    private func didPressedStepper(value: Double) {
        updateValue(value * viewData.stepValue)
    }
    
    private func updateValue(_ newValue: Double) {
        guard (viewData.minimum...viewData.maximum) ~= (value + newValue) else {
            return
        }
        value += newValue
        counterLabel.text = String(value.formatted())
        sendActions(for: .valueChanged)
    
    }
    
    private func stepperButton(color: UIColor, text: String, value: Int) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitle(text, for: .normal)
        button.tag = value
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(color.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = color
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        didPressedStepper(value: Double(sender.tag))
    }
}

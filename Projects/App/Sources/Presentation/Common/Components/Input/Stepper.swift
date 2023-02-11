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

public class Stepper: UIControl {
    
    private let minimum: Double = 1.0
    private let maximum: Double = 20.0
    private let stepValue: Double = 1.0
    private (set) var value: Double = 0
    
    private lazy var plusButton = stepperButton(text: "+", value: 1)
    private lazy var minusButton = stepperButton(text: "-", value: -1)
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.www(size: 72, family: .Light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "1"
        return label
    }()
    
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = 38 - 21.5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ newValue: Double) {
        updateValue(min(maximum, max(minimum, newValue)))
    }
    
    private func setup() {
        backgroundColor = .wwwColor(.WWWWhite)
        self.addSubview(container)
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        container.addArrangedSubviews(minusButton, counterLabel, plusButton)
        
        minusButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        plusButton.layer.cornerRadius = 0.5 * bounds.size.height
        minusButton.layer.cornerRadius = 0.5 * bounds.size.height
    }
    
    private func didPressedStepper(value: Double) {
        updateValue(value * stepValue)
    }
    
    private func updateValue(_ newValue: Double) {
        guard (minimum...maximum) ~= (value + newValue) else {
            return
        }
        value += newValue
        print(value)
        counterLabel.text = String(value.formatted())
        sendActions(for: .valueChanged)
    }
    
    private func stepperButton(text: String, value: Int) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = value
        button.setImage(UIImage(value == 1 ? .add : .delete),
                        for: .disabled)
        button.setImage(UIImage(value == 1 ? .add_fill : .delete_fill),
                        for: .normal)
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        didPressedStepper(value: Double(sender.tag))
    }
}

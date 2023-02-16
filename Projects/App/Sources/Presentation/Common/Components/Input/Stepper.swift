//
//  Stepper.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/11.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

final class Stepper: UIControl {
    
    private let minimum: Double = 1.0
    private let maximum: Double = 20.0
    private var value: Int = 1
    
    public lazy var counterText: UILabel = {
        let label = UILabel()
        label.font = UIFont.www(size: 72, family: .Light)
        label.textAlignment = .center
        label.text = String(value)
        return label
    }()
    
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = 38 - 21.5
        return stack
    }()
    
    public lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(.add), for: .disabled)
        button.setImage(UIImage(.add_fill), for: .normal)
        return button
    }()
    
    public lazy var minusButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setImage(UIImage(.delete),  for: .disabled)
        button.setImage(UIImage(.delete_fill), for: .normal)
        return button
    }()
    
    private func stepperButton(text: String, value: Int, isEnabled: Bool = true) -> UIButton {
        let button = UIButton()
        button.tag = value
        button.isEnabled = isEnabled
        button.setImage(UIImage(value == 1 ? .add : .delete),
                        for: .disabled)
        button.setImage(UIImage(value == 1 ? .add_fill : .delete_fill),
                        for: .normal)
        return button
    }
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        self.addSubview(container)
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        container.addArrangedSubviews(minusButton, counterText, plusButton)
        
        minusButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        plusButton.layer.cornerRadius = 0.5 * bounds.size.height
        minusButton.layer.cornerRadius = 0.5 * bounds.size.height
    }
    
}

extension Stepper {
    public func plusValue() {
        value += 1
        counterText.text = String(value.formatted())
        if value == 2 {
            minusButton.isEnabled = true
        }
        if value == 20 {
            plusButton.isEnabled = false
        }
    }
    
    public func minusValue() {
        value -= 1
        counterText.text = String(value.formatted())
        if value == 19 {
            plusButton.isEnabled = true
        }
        if value == 1 {
            minusButton.isEnabled = false
        }
    }
    
    public func setValue(with newValue: Int) {
        value = newValue
        counterText.text = String(newValue.formatted())
        if value == 2 {
            minusButton.isEnabled = true
        }
        if value == 20 {
            plusButton.isEnabled = false
        }
    }
}

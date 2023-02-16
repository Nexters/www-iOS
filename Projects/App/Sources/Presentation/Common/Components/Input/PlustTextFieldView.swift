//
//  PlustTextFieldView.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/17.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

public final class PlustTextFieldView: UIView {
    public var placeholder: String
    
    public let textField = UITextField()
    private let leftImage = UIImageView()
    private let backgroundView = UIView()
    
    private let msgView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 5
        return $0
    }(UIStackView())
    
    private let plusButton: UIButton = {
        $0.setImage(UIImage(.plus_black), for: .normal)
        $0.setImage(UIImage(.plus_gray), for: .disabled)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIButton())
    
    private let icon: UIImageView = {
        $0.image = UIImage(.plus_black)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let msgLabel: UILabel = {
        $0.numberOfLines = 0
        $0.textColor = UIColor.wwwColor(.WWWRed)
        $0.font = UIFont.www(size: 11)
        return $0
    }(UILabel())
    
    private let cornerRadius: CGFloat = 52/2
    
    public init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlustTextFieldView {
    private func setUI() {
        self.disablePlusButton()
        
        textField.placeholder = placeholder
        textField.clearButtonMode = .never
        textField.returnKeyType = .done
        textField.textColor = .label
        textField.font = UIFont.www.body4
        textField.rightView = plusButton
        textField.rightViewMode = .always
        textField.leftViewMode = .never
        
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundView.layer.borderColor = UIColor.wwwColor(.Gray200).cgColor
        backgroundView.clipsToBounds = true
        
        addSubviews(backgroundView, textField, msgView)
        msgView.addArrangedSubviews(icon, msgLabel)
        
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        plusButton.snp.makeConstraints {
            $0.height.width.equalTo(16)
        }
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(52)
        }
        
    }
    
    private func makeErrorUI() {
        backgroundView.layer.borderColor = UIColor.wwwColor(.WWWRed).cgColor
        msgView.isHidden = false
        icon.snp.makeConstraints {
            $0.leading.equalTo(backgroundView.snp.leading)
            $0.height.width.equalTo(12)
        }

        msgView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    private func makeNormalUI() {
        backgroundView.layer.borderColor = UIColor.wwwColor(.Gray200).cgColor
        msgView.isHidden = true
    }
    
}

extension PlustTextFieldView {
    public func setBorderColor(_ color: CGColor) {
        backgroundView.layer.borderColor = color
    }
    
    public func setErrorMode(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.msgLabel.text = message
            self?.makeErrorUI()
        }
    }
    
    public func setNormalMode() {
        DispatchQueue.main.async { [weak self] in
            self?.msgLabel.text = ""
            self?.makeNormalUI()
        }
    }
    
    public func disablePlusButton() {
        self.plusButton.isEnabled = false
    }
    
    public func enablePlusButton() {
        self.plusButton.isEnabled = true
    }
    
}

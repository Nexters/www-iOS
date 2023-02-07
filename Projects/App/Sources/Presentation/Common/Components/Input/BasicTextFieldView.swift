//
//  BasicTextFieldView.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/07.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

public final class BasicTextFieldView: UIView {
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
    
    private let icon: UIImageView = {
        $0.image = UIImage(.info)
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

extension BasicTextFieldView {
    private func setUI() {
        textField.placeholder = placeholder
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.textColor = .label
        textField.font = UIFont.www.body4
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundView.layer.borderColor = UIColor.wwwColor(.Gray200).cgColor
        backgroundView.clipsToBounds = true
        
        addSubviews(backgroundView, textField)
        
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(52)
        }
        
    }
    
    private func makeErrorUI() {
        addSubviews(msgView)
        msgView.addArrangedSubviews(icon, msgLabel)
        backgroundView.layer.borderColor = UIColor.wwwColor(.WWWRed).cgColor

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
        msgView.removeFromSuperview()
        icon.removeFromSuperview()
        msgView.removeFromSuperview()
    }
    
}

extension BasicTextFieldView {
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
    
}

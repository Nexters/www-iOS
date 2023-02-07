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
}

extension BasicTextFieldView {
    public func setBorderColor(_ color: CGColor) {
        backgroundView.layer.borderColor = color
    }
    
}

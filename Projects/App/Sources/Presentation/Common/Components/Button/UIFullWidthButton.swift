//
//  UIFullWidthButton.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

final class UIFullWidthButton: UIButton {
    
    // MARK: Properties
    
    var title: String = "" {
        didSet {
            setLabel()
        }
    }
    
    var isOnKeyboard: Bool = false {
        didSet {
            setCornerRadius()
        }
    }
    
    var action: UIAction = UIAction(handler: { _ in }) {
        didSet {
            addAction(action, for: .touchUpInside)
        }
    }
    
    // MARK: Life Cycle
    
    convenience init() {
        self.init(configuration: .filled())

        setUI()
        setLayout()
    }
}

// MARK: Methods

extension UIFullWidthButton {
    
    private func setLabel() {
        var titleAttribute = AttributedString(title)
        titleAttribute.font = UIFont.www.body1
        configuration?.attributedTitle = titleAttribute
    }
    
    private func setCornerRadius() {
        if isOnKeyboard {
            configuration?.cornerStyle = .fixed
            configuration?.background.cornerRadius = 0
        } else {
            configuration?.cornerStyle = .capsule
        }
    }
    
    private func setUI() {
        configuration?.baseBackgroundColor = .wwwColor(.WWWBlack)
        configuration?.baseForegroundColor = .wwwColor(.WWWWhite)
        configuration?.cornerStyle = .capsule
    }
    
    private func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(52)
        }
    }
}

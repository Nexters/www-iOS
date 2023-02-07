//
//  UIStackView+.swift
//  www
//
//  Created by Chanhee Jeong on 2023/02/01.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

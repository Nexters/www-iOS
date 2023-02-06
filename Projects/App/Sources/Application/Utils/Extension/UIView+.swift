//
//  UIView+.swift
//  www
//
//  Created by Chanhee Jeong on 2023/02/01.
//

import UIKit

extension UIView {
  func addSubviews(_ views: UIView...) {
    for view in views {
      addSubview(view)
    }
  }
}

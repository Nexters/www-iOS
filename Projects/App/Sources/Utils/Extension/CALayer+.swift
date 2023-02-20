//
//  CALayer+.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
// https://stackoverflow.com/questions/34269399/how-to-control-shadow-spread-and-blur

import Foundation
import UIKit

extension CALayer {
  func applyFigmaShadow(
    color: UIColor = .black,
    opacity: Float = 0.25,
    x: CGFloat = 0,
    y: CGFloat = 0,
    blur: CGFloat = 5,
    spread: CGFloat = 0) {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = opacity
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}

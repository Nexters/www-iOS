//
//  CALayer+.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
// https://stackoverflow.com/questions/34269399/how-to-control-shadow-spread-and-blur
// https://stackoverflow.com/questions/15193993/how-to-make-a-gradient-border-of-uiview

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
    
    func addGradienBorder(colors:[UIColor], width:CGFloat = 1) {
         let gradientLayer = CAGradientLayer()
         gradientLayer.frame =  CGRect(origin: CGPointZero, size: self.bounds.size)
         gradientLayer.startPoint = CGPointMake(0.0, 0.5)
         gradientLayer.endPoint = CGPointMake(1.0, 0.5)
         gradientLayer.colors = colors.map({$0.cgColor})

         let shapeLayer = CAShapeLayer()
         shapeLayer.lineWidth = width
         shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
         shapeLayer.fillColor = nil
         shapeLayer.strokeColor = UIColor.black.cgColor
         gradientLayer.mask = shapeLayer

         self.addSublayer(gradientLayer)
     }
}

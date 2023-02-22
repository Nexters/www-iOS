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
    
    
    /// .addGradientLayer
    /// - This will add a gradient layer with red to blue gradient, starting at the top-left corner of myView and ending at the bottom-right corner.
    /// - REF : ChatGPT🤖
    ///
    /// ```
    /// myView.addGradientLayer(colors: [UIColor.red.cgColor, UIColor.blue.cgColor], locations: nil, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
    /// ```
    func addGradientLayer(colors: [CGColor], locations: [NSNumber]?, startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func setRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        var masked = CACornerMask()
        if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
        if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
        if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
        if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
        self.layer.maskedCorners = masked
    }
}

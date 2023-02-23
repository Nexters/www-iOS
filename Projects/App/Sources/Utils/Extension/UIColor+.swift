//
//  UIColor+.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/08.
//  Copyright © 2023 com.promise8. All rights reserved.
//


import UIKit

/// 🎨 WWW Color 사용가이드
///
/// ```
/// self.view.backgroundColor = UIColor.wwwColor(.WWWGreen)
/// ```

enum WWWColor: String {
    case WWWGreen
    case WWWRed
    case WWWMint // Gradient
    
    case WWWBlack
    case WWWWhite
    case Gray800
    case Gray750
    case Gray700
    case Gray650
    case Gray600
    case Gray550
    case Gray500
    case Gray450
    case Gray400
    case Gray350
    case Gray300
    case Gray250
    case Gray200
    case Gray150
    case Gray100
    case Gray50
}

extension UIColor {
    static func wwwColor(_ color: WWWColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}

//
//  Font+.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/08.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import SwiftUI
import UIKit


extension UIFont {
    
    static let theme = WWWFont()
    
    enum Family: String {
        case Bold, Medium, Regular, Light, Thin
    }
    
    /// let spoqahansansneoBold = UIFont.www(size: 10, family: .Bold)
    static func www(size: CGFloat = 10, family: Family = .Regular) -> UIFont {
        return UIFont(name: "SpoqaHanSansNeo-\(family)", size: size)!
    }

}

extension Font {
    static let theme = WWWFont()
}


struct WWWFont {
    fileprivate init () { }

    let heading1 = UIFont.www(size: 72, family: .Light)
    let heading2 = UIFont.www(size: 36, family: .Medium)
    let heading3 = UIFont.www(size: 24, family: .Medium)
    
    let title1 = UIFont.www(size: 22, family: .Bold)
    let title2 = UIFont.www(size: 22, family: .Medium)
    let title3 = UIFont.www(size: 20, family: .Bold)
    let title4 = UIFont.www(size: 20, family: .Medium)
    let title5 = UIFont.www(size: 18, family: .Bold)
    let title6 = UIFont.www(size: 18, family: .Medium)
    let title7 = UIFont.www(size: 16, family: .Bold)
    let title8 = UIFont.www(size: 16, family: .Medium)
    let title9 = UIFont.www(size: 16, family: .Regular)
    
    let body1 = UIFont.www(size: 15, family: .Medium)
    let body2 = UIFont.www(size: 14, family: .Bold)
    let body3 = UIFont.www(size: 14, family: .Medium)
    let body4 = UIFont.www(size: 14, family: .Regular)
    let body5 = UIFont.www(size: 12, family: .Bold)
    let body6 = UIFont.www(size: 12, family: .Medium)
    let body7 = UIFont.www(size: 11, family: .Bold)
    let body8 = UIFont.www(size: 11, family: .Regular)

}

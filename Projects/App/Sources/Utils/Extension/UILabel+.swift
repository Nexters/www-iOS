//
//  UILabel+.swift
//  App
//
//  Created by kokojong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

extension UILabel {
    func customAttributedString(text: String, highlightText: String,
                                       textFont: UIFont, highlightTextFont: UIFont,
                                       textColor: UIColor, highlightTextColor: UIColor,
                                       bgText: String? = nil, bgTextFont: UIFont? = nil, bgTextColor: UIColor? = nil, bgColor: UIColor? = nil) {
      var attributedText = NSMutableAttributedString()
      let defaultString = String(format: text, highlightText)
      attributedText = NSMutableAttributedString(string: defaultString as String,
                                            attributes: [NSAttributedString.Key.font: textFont,
                                                         NSAttributedString.Key.foregroundColor: textColor])   //default 폰트,색상
      attributedText.addAttribute(NSAttributedString.Key.font,
                             value: highlightTextFont,
                             range: (defaultString as NSString).range(of: highlightText))
      
      attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                  value: highlightTextColor,
                                  range: (defaultString as NSString).range(of: highlightText))
      if let bgText = bgText, let bgTextFont = bgTextFont, let bgTextColor = bgTextColor, let bgColor = bgColor {
        attributedText.addAttribute(NSAttributedString.Key.backgroundColor,
                                    value: bgColor,
                                    range: (defaultString as NSString).range(of: bgText))
        attributedText.addAttribute(NSAttributedString.Key.font,
                               value: bgTextFont,
                               range: (defaultString as NSString).range(of: bgText))
        
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                    value: bgTextColor,
                                    range: (defaultString as NSString).range(of: bgText))
      }
    
        self.attributedText = attributedText
    }
}

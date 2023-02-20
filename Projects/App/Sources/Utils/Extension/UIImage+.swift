//
//  UIImage+.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/08.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

public extension UIImage {
    convenience init?(_ asset: WWWAssset) {
        self.init(named: asset.rawValue, in: Bundle.module, with: nil)
    }

    convenience init?(assetName: String) {
        self.init(named: assetName, in: Bundle.module, with: nil)
    }
    
    func resized(to size: CGSize) -> UIImage {
      return UIGraphicsImageRenderer(size: size).image { _ in
        draw(in: CGRect(origin: .zero, size: size))
      }
    }
}

//
//  Double+.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

extension Double {
    var horizontallyAdjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        return CGFloat(self) * ratio
    }
    
    var verticallyAdjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 812
        return self * ratio
    }
}


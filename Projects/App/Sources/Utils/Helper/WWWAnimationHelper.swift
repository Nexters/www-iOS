//
//  WWWAnimationHelper.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/18.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

final class WWWAnimationHelper {
    
    static let shared = WWWAnimationHelper()

    private init() { }

    func applyParallaxEffect(to view: UIView, magnitue: Float = 50) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -magnitue
        horizontal.maximumRelativeValue = magnitue

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -magnitue
        vertical.maximumRelativeValue = magnitue

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
    }
}

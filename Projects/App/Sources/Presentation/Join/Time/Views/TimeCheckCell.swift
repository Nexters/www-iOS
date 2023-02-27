//
//  TimeCheckCell.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/20.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

enum CheckStatus {
    case notSelected
    case selected
    case disabled
}

final class TimeCheckCell: UICollectionViewCell {
    
    var isClicked = false
    var status: CheckStatus = .notSelected
    
    let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(.time_default)
        return $0
    }(UIImageView())

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubviews(imageView)
            
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    
    func configure(status: CheckStatus) {
        self.status = status
        switch status {
        case .notSelected:
            imageView.image = UIImage(.time_default)
        case .selected:
            imageView.image = UIImage(.time_selected)
        case .disabled:
            imageView.image = UIImage(.time_disabled)
        }
    }
    
     func changeImage(with status: CheckStatus){
         switch status {
         case .notSelected:
             UIView.animate(withDuration: 0.1) {
                 self.imageView.image = UIImage(.time_default)
             }
         case .selected:
             UIView.animate(withDuration: 0.1) {
                 self.imageView.image = UIImage(.time_selected)
             }
         case .disabled:
             break
         }
    }

}

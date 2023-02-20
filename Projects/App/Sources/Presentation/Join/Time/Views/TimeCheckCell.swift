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
    
    private var isClicked = false
    
    private let imageView: UIImageView = {
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
    
    func configure(status: CheckStatus) {
        if status == .disabled {
            imageView.image = UIImage(.time_disabled)
            imageView.isUserInteractionEnabled = false
        }
    }
    
    func onSelected() {
        isClicked = !isClicked
        changeImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func changeImage(){
        if isClicked {
            UIView.animate(withDuration: 0.1) {
                self.imageView.image = UIImage(.time_selected)
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.imageView.image = UIImage(.time_default)
            }
        }
    }

}

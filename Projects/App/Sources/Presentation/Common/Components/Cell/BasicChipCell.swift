//
//  BasicChipCell.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/16.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

import SnapKit

final class BasicChipCell: SelfSizingCollectionViewCell {
    static let identifier = "BasicChip"
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.wwwColor(.Gray700)
        label.numberOfLines = 1
        label.font = UIFont.www.body4
        return label
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.contentView.backgroundColor = UIColor.wwwColor(.WWWGreen).withAlphaComponent(0.08)
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.wwwColor(.WWWGreen).cgColor
        
        self.contentView.addSubview(placeLabel)
        
        self.contentView.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    func configure(_ title: String) {
        self.placeLabel.text = title
    }
}

//
//  ParticipantCell.swift
//  App
//
//  Created by kokojong on 2023/02/25.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

final class ParticipantCell: UICollectionViewCell {
    static let identifier = "ParticipantCell"
    
    private let profileImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(.profileImg)
        return imgView
    }()
    
    private let profileBadgeImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(.profileBadge)
        return imgView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .www.title9
        label.textColor = .wwwColor(.WWWBlack)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.contentView.backgroundColor = .wwwColor(.WWWWhite)
        self.contentView.addSubview(profileImgView)
        profileImgView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(44)
        }
        
        self.contentView.addSubview(profileBadgeImgView)
        profileBadgeImgView.snp.makeConstraints {
            $0.trailing.equalTo(profileImgView).offset(2)
            $0.bottom.equalTo(profileImgView)
            $0.size.equalTo(16)
        }
        
        self.contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImgView.snp.trailing).offset(18)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setData(user: User) {
        profileBadgeImgView.isHidden = !user.isHost
        userNameLabel.text = user.name
    }
}

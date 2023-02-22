//
//  VotingAlertView.swift
//  App
//
//  Created by kokojong on 2023/02/22.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

enum VotingAlertType {
    case startVoting
    case endVoting
}

final class VotingAlertView: UIView {
    
    private let bgView: UIView = {
        $0.backgroundColor = .wwwColor(.WWWBlack).withAlphaComponent(0.7)
        return $0
    }(UIView())
    
    private let contentView: UIView = {
        $0.backgroundColor = .white
        $0.setRoundCorners(.allCorners, radius: 20)
        return $0
    }(UIView())
    
    private let votingImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(.votingBox)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    private let titleLabel: UILabel = {
        $0.text = "투표를 시작하시겠어요?"
        $0.font = .www.title6
        $0.textColor = .wwwColor(.Gray700)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.text = "투표가 시작되면\n새로운 참가자를 더 이상 받지 못해요"
        $0.font = .www.body3
        $0.textColor = .wwwColor(.Gray400) // TODO: www color 수정
        $0.numberOfLines = 2
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let btnStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.wwwColor(.Gray100).cgColor
        return $0
    }(UIStackView())
    
    let cancelBtn: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.titleAlignment = .center
        
        let btn = UIButton(configuration: config)
        btn.tintColor = .wwwColor(.Gray400)
        return btn
    }()
    
    let confirmBtn: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.titleAlignment = .center
        
        let btn = UIButton(configuration: config)
        btn.tintColor = .wwwColor(.WWWGreen)
        return btn
    }()
    
    init(type: VotingAlertType) {
        super.init(frame: .zero)
        setUI()
        configUI(type)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300.horizontallyAdjusted)
            $0.height.equalTo(265)
        }
        
        addSubview(votingImgView)
        votingImgView.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(190)
        }
        
        contentView.addSubviews(titleLabel, descriptionLabel, btnStackView)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(votingImgView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        btnStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(25)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        btnStackView.addArrangedSubviews(cancelBtn, confirmBtn)
    }
    
    private func configUI(_ type: VotingAlertType) {
        switch type {
        case .startVoting:
            titleLabel.text = "투표를 시작하시겠어요?"
            descriptionLabel.text = "투표가 시작되면\n새로운 참가자를 더 이상 받지 못해요"
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.www(size: 15, family: .Medium) as Any]
            let cancelAttrStr: NSAttributedString = .init(string: "관둘래요", attributes: attributes)
            let confimAttrStr: NSAttributedString = .init(string: "네, 시작할래요", attributes: attributes)
            cancelBtn.setAttributedTitle(cancelAttrStr, for: .normal)
            confirmBtn.setAttributedTitle(confimAttrStr, for: .normal)
            
        case .endVoting:
            titleLabel.text = "투표를 종료하시겠어요?"
            descriptionLabel.text = "투표가 종료되면 재투표는 불가능해요"
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.www(size: 15, family: .Medium) as Any]
            let cancelAttrStr: NSAttributedString = .init(string: "관둘래요", attributes: attributes)
            let confimAttrStr: NSAttributedString = .init(string: "네, 종료할래요", attributes: attributes)
            cancelBtn.setAttributedTitle(cancelAttrStr, for: .normal)
            confirmBtn.setAttributedTitle(confimAttrStr, for: .normal)
        }
    }
    
}

//
//  PopUpModalView.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

final class PopUpModalView: UIView {
    
    private let bgView: UIView = {
        $0.backgroundColor = .wwwColor(.WWWBlack).withAlphaComponent(0.7)
        return $0
    }(UIView())
    
    private let contentView = UIView()
    
    private let boxView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(.gradient_round)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let yaksokiView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(.painting)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let descriptionLabel: UILabel = {
        let attributedString = NSMutableAttributedString(string: "투표가 시작됐어요\n 지금 바로 원하는 장소에 투표해주세요")
        let greenAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.wwwColor(.WWWGreen),
            NSAttributedString.Key.font: UIFont.www.body1 as Any
        ]
        let blackAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.wwwColor(.Gray700),
            NSAttributedString.Key.font: UIFont.www.body1 as Any
        ]

        attributedString.addAttributes(greenAttributes, range: NSRange(location: 16, length: 7))
        attributedString.addAttributes(blackAttributes, range: NSRange(location: 0, length: 16))
        attributedString.addAttributes(blackAttributes, range: NSRange(location: 23, length: attributedString.length - 23))

        
        $0.attributedText = attributedString
        
        $0.numberOfLines = 2
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var goToVoteButton: LargeButton = {
        $0.setTitle("투표하러 가기", for: .normal)
        $0.setButtonState(true)
        return $0
    }(LargeButton())
    
    init() {
        super.init(frame: .zero)
        setUI()
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
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(320)
        }
        
        contentView.addSubview(boxView)
        boxView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(268.verticallyAdjusted)
        }
        
        contentView.addSubview(yaksokiView)
        yaksokiView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(245.horizontallyAdjusted)
            make.height.equalTo(149.verticallyAdjusted)
        }

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(yaksokiView.snp.bottom).offset(12.verticallyAdjusted)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(45.verticallyAdjusted)
            make.width.equalTo(245.horizontallyAdjusted)
        }

        contentView.addSubview(goToVoteButton)
        goToVoteButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(56.verticallyAdjusted)
        }
        
 
    }

}

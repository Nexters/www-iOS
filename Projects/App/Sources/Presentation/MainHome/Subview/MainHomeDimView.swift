//
//  MainHomeDimView.swift
//  App
//
//  Created by kokojong on 2023/02/12.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

final class MainHomeDimView: UIView {
    
    let addPromiseButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        var attrStr = AttributedString("새로운 약속 생성하기")
        attrStr.font = .www.body2
        attrStr.foregroundColor = .wwwColor(.WWWWhite)
        config.attributedTitle = attrStr
        config.baseBackgroundColor = .wwwColor(.WWWBlack)
        config.titleAlignment = .center
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 14, leading: 14, bottom: 14, trailing: 14)
        button.configuration = config
        return button
    }()
    
    let enterWithCodeButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        var attrStr = AttributedString("초대코드로 입장하기")
        attrStr.font = .www.body2
        attrStr.foregroundColor = .wwwColor(.WWWBlack)
        config.attributedTitle = attrStr
        config.baseBackgroundColor = .wwwColor(.WWWWhite)
        config.titleAlignment = .center
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 14, leading: 14, bottom: 14, trailing: 14)
        button.configuration = config
        return button
    }()
    
    let floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(.floating_cancel), for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .wwwColor(.WWWBlack).withAlphaComponent(0.7)
        
        self.addSubview(addPromiseButton)
        addPromiseButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(150.horizontallyAdjusted)
            $0.height.equalTo(46)
        }
        
        addSubview(enterWithCodeButton)
        enterWithCodeButton.snp.makeConstraints {
            $0.top.equalTo(addPromiseButton.snp.bottom).offset(14)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(150.horizontallyAdjusted)
            $0.height.equalTo(46)
        }
        
        self.addSubview(floatingButton)
        floatingButton.snp.makeConstraints {
            $0.top.equalTo(enterWithCodeButton.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.size.equalTo(64)
        }
    }

}


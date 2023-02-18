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
        let button = UIButton()
        button.backgroundColor = .wwwColor(.WWWBlack)
        button.clipsToBounds = true
        button.layer.cornerRadius = 46/2
        button.setTitleColor(.wwwColor(.WWWWhite), for: .normal)
        button.setTitle("새로운 약속 생성하기", for: .normal)
        button.titleLabel?.font = .www(size: 14, family: .Bold)
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        return button
    }()
    
    let enterWithCodeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .wwwColor(.WWWWhite)
        button.clipsToBounds = true
        button.layer.cornerRadius = 46/2
        button.setTitleColor(.wwwColor(.WWWBlack), for: .normal)
        button.setTitle("초대코드로 입장하기", for: .normal)
        button.titleLabel?.font = .www(size: 14, family: .Bold)
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        return button
    }()
    
    let floatingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .wwwColor(.WWWBlack)
        button.clipsToBounds = true
        button.setImage(UIImage(.delete_fill), for: .normal)
        button.layer.cornerRadius = 64/2
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
            $0.height.equalTo(46)
        }
        
        addSubview(enterWithCodeButton)
        enterWithCodeButton.snp.makeConstraints {
            $0.top.equalTo(addPromiseButton.snp.bottom).offset(14)
            $0.trailing.equalToSuperview().inset(20)
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


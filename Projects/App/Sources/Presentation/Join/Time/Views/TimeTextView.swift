//
//  TimeTextView.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

final class TimeTextView: UIView {
    
    private var titleLabel: UILabel = {
        $0.text = "아침🥚"
        $0.textAlignment = .left
        $0.textColor = UIColor.wwwColor(.WWWBlack)
        $0.font = UIFont.www.body3
        return $0
    }(UILabel())
    
    private var subLabel: UILabel = {
        $0.text = "06-10시"
        $0.textAlignment = .left
        $0.textColor = UIColor.wwwColor(.Gray500)
        $0.font = UIFont.www.body6
        return $0
    }(UILabel())
    
    
    public init(title: String, sub: String) {
        super.init(frame: .zero)
        setUI()
        configure(title: title, sub: sub)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// MARK: - UI
extension TimeTextView {
    private func setUI() {
        self.addSubviews(titleLabel, subLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2.verticallyAdjusted)
            make.leading.equalToSuperview()
        }

        if DeviceManager.shared.isHomeButtonDevice() {
            titleLabel.font = UIFont.www.body5
            subLabel.font = UIFont.www.body8
        }
        
    }
}

// MARK: - Bind
extension TimeTextView {
    private func configure(title: String, sub: String) {
        titleLabel.text = title
        subLabel.text = sub
    }
}

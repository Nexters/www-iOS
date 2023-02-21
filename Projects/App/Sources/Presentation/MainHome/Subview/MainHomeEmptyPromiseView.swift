//
//  MainHomeEmptyPromiseView.swift
//  App
//
//  Created by kokojong on 2023/02/12.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

final class MainHomeEmptyPromiseView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .wwwColor(.Gray250)
        label.font = .www.title6
        return label
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
}

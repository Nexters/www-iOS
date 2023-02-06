//
//  ProgressView.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/07.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

// TODO: 색깔적용
final class ProgressView: UIView {
    
    private lazy var progressView = UIProgressView()
    
    public init(current: Int, total: Int) {
        super.init(frame: .zero)
        setUI(prog: Float(current) / Float(total))
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProgressView {
    private func setUI(prog: Float) {
        self.addSubview(progressView)
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .black
        progressView.progress = prog
        progressView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(3)
        }
    }
}

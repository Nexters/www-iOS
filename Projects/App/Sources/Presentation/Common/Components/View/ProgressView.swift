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
/// ProgressView : Progress 상황에서 사용
/// - current: 표시 / total : 전체
/// - 레이아웃:  Top 과 가로만 맞추면됩니다
///
/// ```
/// // 속성
/// private let progressView = ProgressView(current: 1, total: 6)
///
/// // 레이아웃
/// progressView.snp.makeConstraints {
///    $0.top.equalTo(view.safeAreaLayoutGuide)
///    $0.horizontalEdges.equalToSuperview()
/// }
/// ```
///
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
            make.height.equalTo(2)
        }
    }
}

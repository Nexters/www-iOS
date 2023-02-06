//
//  MainTitleView.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/07.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

// TODO: 폰트 및 색깔적용

/// BasicTitleView : 기본타이틀뷰
///
/// 레이아웃
/// - Top : safeAreaLayoutGuide에 맞추기
/// - 가로 맞추기
///
/// ```
/// // 버튼 속성 예시
/// private lazy var nextButton: LargeButton(state: true)
/// nextButton.setTitle("다음", for: .normal)
/// nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
///
/// // 레이아웃 예시
/// $0.top.equalTo(view.safeAreaLayoutGuide)
/// $0.horizontalEdges.equalToSuperview()
/// ```
///
final class BasicTitleView: UIView {
    
    public var titleLabel = UILabel()
    public var subtitleLabel = UILabel()
    private var titleStackView = UIStackView()
    
    public init(title: String, subTitle: String = "") {
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subTitle
        setUI(subTitle: subTitle)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BasicTitleView {
    private func setUI(subTitle: String) {
        
        titleStackView.spacing = 6
        titleStackView.axis = .vertical
        titleStackView.distribution = .fill

        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)

        if !subTitle.isEmpty {
            subtitleLabel.textColor = .gray
            subtitleLabel.numberOfLines = 0
            subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        }
        
        
        addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        if !subTitle.isEmpty {
            titleStackView.addArrangedSubview(subtitleLabel)
            
            subtitleLabel.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
            }
        }
        
    }
}

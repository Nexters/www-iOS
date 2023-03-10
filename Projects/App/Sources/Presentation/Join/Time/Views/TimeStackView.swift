//
//  TimeStackView.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright ยฉ 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

final class TimeStackView: UIView {
    
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 10.verticallyAdjusted
        return $0
    }(UIStackView())
    
    private let morning = TimeTextView(title:"์์นจ๐ฅ", sub: "06-10์")
    private let lunch = TimeTextView(title:"๋ฎ๐", sub: "11-16์")
    private let dinner = TimeTextView(title:"์ ๋๐", sub: "17-20์")
    private let night = TimeTextView(title:"๋ฐค๐ป", sub: "21-24์")
    
    public init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// MARK: - UI
extension TimeStackView {
    private func setUI() {
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.stackView.addArrangedSubviews(morning, lunch, dinner, night)

        morning.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(64.verticallyAdjusted)
        }
        lunch.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(64.verticallyAdjusted)
        }
        dinner.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(64.verticallyAdjusted)
        }
        night.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(64.verticallyAdjusted)
        }
    }
}

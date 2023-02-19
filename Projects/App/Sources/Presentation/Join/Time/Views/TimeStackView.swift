//
//  TimeStackView.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
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
    
    private let morning = TimeTextView(title:"아침🥚", sub: "06-10시")
    private let lunch = TimeTextView(title:"낮🔅", sub: "11-16시")
    private let dinner = TimeTextView(title:"저녁🌙", sub: "17-20시")
    private let night = TimeTextView(title:"밤🍻", sub: "21-24시")
    
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
            make.height.equalTo(34.verticallyAdjusted)
        }
        lunch.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(34.verticallyAdjusted)
        }
        dinner.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(34.verticallyAdjusted)
        }
        night.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(34.verticallyAdjusted)
        }
    }
}

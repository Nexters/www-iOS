//
//  DateStackView.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

final class DateStackView: UIView {
    
    private var stackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 10.horizontallyAdjusted
        return $0
    }(UIStackView())
    
    private var dateLabel1: UILabel = {
        $0.text = "25 (토)"
        $0.textAlignment = .center
        $0.textColor = UIColor.wwwColor(.WWWBlack)
        $0.font = UIFont.www.body4
        return $0
    }(UILabel())
    
    private var dateLabel2: UILabel = {
        $0.text = "26 (일)"
        $0.textAlignment = .center
        $0.textColor = UIColor.wwwColor(.WWWBlack)
        $0.font = UIFont.www.body4
        return $0
    }(UILabel())
    
    private var dateLabel3: UILabel = {
        $0.text = "27 (월)"
        $0.textAlignment = .center
        $0.textColor = UIColor.wwwColor(.WWWBlack)
        $0.font = UIFont.www.body4
        return $0
    }(UILabel())
    
    private var dateLabel4: UILabel = {
        $0.text = "28 (화)"
        $0.textAlignment = .center
        $0.textColor = UIColor.wwwColor(.WWWBlack)
        $0.font = UIFont.www.body4
        return $0
    }(UILabel())
    
    
    public init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// MARK: - UI
extension DateStackView {
    private func setUI() {
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.stackView.addArrangedSubviews(dateLabel1, dateLabel2, dateLabel3, dateLabel4)
        
        dateLabel1.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(34.verticallyAdjusted)
        }
        dateLabel2.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(34.verticallyAdjusted)
        }
        dateLabel3.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(34.verticallyAdjusted)
        }
        dateLabel4.snp.makeConstraints { make in
            make.width.equalTo(59.horizontallyAdjusted)
            make.height.equalTo(34.verticallyAdjusted)
        }
    }
}

// MARK: - Bind
extension DateStackView {
    private func setDate(with dates: [Date]) {
        
    }
}

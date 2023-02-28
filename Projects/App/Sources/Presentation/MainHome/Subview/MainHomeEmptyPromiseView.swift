//
//  MainHomeEmptyPromiseView.swift
//  App
//
//  Created by kokojong on 2023/02/12.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

final class MainHomeEmptyPromiseView: UIView {
    
    enum SelectedStatus: String {
        case proceeding = "아직 진행 중인 약속이 없어요!"
        case ended = "아직 종료된 약속이 없어요!"
    }
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .wwwColor(.Gray250)
        label.font = .www.title6
        return label
    }()
    
    init(status: SelectedStatus) {
        super.init(frame: .zero)
        messageLabel.text = status.rawValue
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
    
    func changeStatus(status: SelectedStatus) {
        messageLabel.text = status.rawValue
    }
    
}

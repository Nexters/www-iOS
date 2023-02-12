//
//  MainHomePromiseCell.swift
//  App
//
//  Created by kokojong on 2023/02/12.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

final class MainHomePromiseCell: UICollectionViewCell {
    static let identifier = "MainHomePromiseCell"
    
    // MARK: - UI
    private let statusLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.backgroundColor = .wwwColor(.WWWGreen)
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    func setData(data: Int) {
        statusLabel.text = "test\(data)"
    }
    
    
}

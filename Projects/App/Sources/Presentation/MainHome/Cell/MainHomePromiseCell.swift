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
        label.font = UIFont.www.title8
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    
    private let titleLabel: PaddingLabel = {
        let label = PaddingLabel(padding: .init(top: 8, left: 24, bottom: 8, right: 24))
        label.backgroundColor = .wwwColor(.WWWWhite)
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    
    private let characterImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "heart")?.resized(to: .init(width: 200, height: 230))
        return imgView
    }()
    
    private let usersIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(.users)
        return imgView
    }()
    
    private let usersLabel: UILabel = {
        let label = UILabel()
        label.font = .www(size: 13, family: .Medium)
        label.textColor = .wwwColor(.WWWGreen)
        return label
    }()
    
    private let calendarIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(.calendar)
        return imgView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .www(size: 15, family: .Medium)
        label.textColor = .wwwColor(.Gray750)
        return label
    }()
    
    private let placeIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(.place)
        return imgView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .www(size: 15, family: .Medium)
        label.textColor = .wwwColor(.Gray750)
        return label
    }()
    
    private let pageLabel: PaddingLabel = {
        let label = PaddingLabel(padding: .init(top: 2, left: 14, bottom: 2, right: 14))
        label.backgroundColor = .wwwColor(.WWWWhite)
        label.clipsToBounds = true
        label.layer.cornerRadius = 26/2
        label.font = .www(size: 15, family: .Medium)
        label.textColor = .wwwColor(.WWWGreen)
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
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
        
        addSubview(labelStackView)
        labelStackView.addArrangedSubviews(titleLabel, usersLabel, dateLabel, placeLabel, pageLabel)
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(25)
        }
        
    }
    
    func setData(data: Int) {
        statusLabel.text = "test\(data)"
        
        titleLabel.text = "title"
        usersLabel.text = "3/4명"
        dateLabel.text = "23.02.13 오전"
        placeLabel.text = "강남역"
        pageLabel.text = "1/3"
    }
    
    
}

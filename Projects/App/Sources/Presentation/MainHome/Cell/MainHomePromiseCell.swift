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
        let label = PaddingLabel(padding: UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10))
        label.backgroundColor = .wwwColor(.WWWGreen)
        label.font = UIFont.www(size: 13, family: .Bold)
        label.textColor = .wwwColor(.WWWWhite)
        label.setRoundCorners([.topLeft, .topRight], radius: 6)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .wwwColor(.WWWBlack)
        label.font = .www.title8
        label.textAlignment = .left
        return label
    }()
    
    private let titleLabelBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .wwwColor(.WWWGreen).withAlphaComponent(0.2)
        return view
    }()
    
    private let promiseView: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(.promiseFrame)
        return view
    }()
    
    private let characterImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let usersView: UIView = {
        let view = UIView()
        view.backgroundColor = .wwwColor(.WWWGreen).withAlphaComponent(0.1)
        view.setRoundCorners([.topLeft, .topRight], radius: 6)
        return view
    }()
    
    private let usersIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(.users)
        return imgView
    }()
    
    private let usersLabel: UILabel = {
        let label = UILabel()
        label.font = .www(size: 13, family: .Bold)
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
        label.font = .www.body3
        label.textColor = .wwwColor(.Gray700)
        label.textAlignment = .left
        return label
    }()
    
    private let placeIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(.place)
        return imgView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .www.body3
        label.textColor = .wwwColor(.Gray700)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImgView.image = nil
    }
    
    private func setUI() {
        addSubview(promiseView)
        promiseView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.centerX.equalToSuperview()
        }
        
        promiseView.addSubviews(titleLabel, titleLabelBgView, calendarIcon, dateLabel, placeIcon, placeLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(18)
            $0.height.equalTo(22)
        }
        
        titleLabelBgView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.centerY)
            $0.horizontalEdges.equalTo(titleLabel)
            $0.height.equalTo(titleLabel).multipliedBy(0.5)
        }
        
        calendarIcon.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.centerY.equalTo(dateLabel)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(calendarIcon.snp.trailing).offset(8)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        placeIcon.snp.makeConstraints{
            $0.leading.equalTo(titleLabel)
            $0.centerY.equalTo(placeLabel)
        }
        
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(placeIcon.snp.trailing).offset(8)
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        addSubview(characterImgView)
        characterImgView.snp.makeConstraints {
            $0.top.equalTo(promiseView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(250)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.bottom.equalTo(promiseView.snp.top)
        }
        
        addSubview(usersView)
        usersView.snp.makeConstraints {
            $0.bottom.equalTo(promiseView.snp.top)
            $0.leading.equalTo(statusLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(promiseView).inset(16)
        }
        
        usersView.addSubviews(usersIcon, usersLabel)
        usersIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(4)
        }
        usersLabel.snp.makeConstraints {
            $0.centerY.equalTo(usersIcon)
            $0.trailing.equalToSuperview().inset(10)
            $0.leading.equalTo(usersIcon.snp.trailing).offset(4)
        }
        
    }
    
    func setData(_ data: MeetingMain) {
        
        statusLabel.text = data.meetingStatus.toText(data.confirmedDate?.toDate())
        titleLabel.text = data.meetingName
        usersLabel.text = "\(data.votingUserCount)/\(data.joinedUserCount)"
        characterImgView.image = data.yaksokiType.toImg()
        if let confirmedDate = data.confirmedDate, let confirmedTime = data.confirmedTime {
            dateLabel.textColor = .wwwColor(.Gray700)
            dateLabel.text = "\(confirmedDate)• \(confirmedTime.toText())"
        } else {
            dateLabel.text = "미확정"
            dateLabel.textColor = .wwwColor(.Gray250)
        }
        
        if let confirmPlace = data.confirmedPlace {
            placeLabel.textColor = .wwwColor(.Gray700)
            placeLabel.text = confirmPlace
        } else {
            placeLabel.textColor = .wwwColor(.Gray250)
            placeLabel.text = "미확정"
        }
    }
    
    
}

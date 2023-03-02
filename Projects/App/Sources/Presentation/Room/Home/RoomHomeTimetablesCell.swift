//
//  RoomHomeTimetablesCell.swift
//  App
//
//  Created by kokojong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

enum RoomTimetablesCellType {
    case fill
    case other
}

final class RoomHomeTimetablesCell: UITableViewCell {
    // MARK: - Properties
    static let id = "RoomHomeTimetablesCell"
    lazy var progress: CGFloat = 0.3
    
    // MARK: - UI
    private let container: UIView = {
        $0.layer.cornerRadius = 15
        return $0
    }(UIView())
    
    private let containerView: UIView = {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .wwwColor(.Gray100)
        return $0
    }(UIView())
    
    private let colorView = {
        $0.layer.cornerRadius = 15
        return $0
    }(UIView())
    
    private let nameLabel: UILabel = {
        $0.numberOfLines = 1
        $0.textColor = UIColor.wwwColor(.Gray700)
        $0.font = UIFont.www.body1
        return $0
    }(UILabel())
    
    private let countLabel: UILabel = {
        $0.numberOfLines = 1
        $0.textColor = UIColor.wwwColor(.Gray450)
        $0.font = UIFont.www.body3
        $0.text = "0명"
        return $0
    }(UILabel())
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progress = 0.0
    }
    
}

extension RoomHomeTimetablesCell {
    
    func configure(rank: Int, title: String, count: Int, total: Int) {
        nameLabel.text = title
        countLabel.text = "\(count)명"
        
        progress = CGFloat(count) / CGFloat(total)
        
        setProgress(progress: progress)
        
        if progress >= 1 {
            setGradient(type: .fill)
        } else {
            setGradient(type: .other)
        }
        
        let badgeView: UIImageView = {
            var img: UIImage? = UIImage()
            switch rank {
            case 1: img = UIImage(.rank1)
            case 2: img = UIImage(.rank2)
            case 3: img = UIImage(.rank3)
            default: img = nil
            }
            $0.image = img
            return $0
        }(UIImageView())
        
        containerView.addSubview(badgeView)
        badgeView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
        }
        
        if rank == 1 {
            badgeView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(-8)
                $0.leading.equalToSuperview().inset(13)
            }
        }
        
    }

}



// MARK: - Private Methods
extension RoomHomeTimetablesCell {
    
    private func setUI() {
        contentView.addSubviews(container)

        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20))
        }
        
        container.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300.horizontallyAdjusted)
            make.height.equalTo(48.verticallyAdjusted)
        }
    }
    
    private func setProgress(progress: CGFloat) {
        
        container.addSubview(colorView)
        
        colorView.layer.cornerRadius = 15
        colorView.layer.masksToBounds = true
        
        let width = (300.horizontallyAdjusted) * progress
        
        containerView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(48.verticallyAdjusted)
        }
        
        containerView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(43.horizontallyAdjusted)
            $0.centerY.equalToSuperview()
        }
        
        self.layoutIfNeeded()
    }
    
    private func setGradient(type: RoomTimetablesCellType) {
        
        var opacity = 0.0
        switch type {
        case .fill: opacity = 1.0
        case .other: opacity = 0.3
        }
        
        self.layoutIfNeeded()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.locations = [0.0, 1.0]
        let colors: [CGColor] = [
            UIColor.wwwColor(.WWWMint).withAlphaComponent(opacity).cgColor,
            UIColor.wwwColor(.WWWGreen).withAlphaComponent(opacity).cgColor
        ]
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.5)
        gradient.frame = .init(x: 0, y: 0,
                               width: self.colorView.frame.width,
                               height: self.colorView.frame.height)
        if let sublayers = colorView.layer.sublayers, sublayers.count > 0 {
            let indexToRemove = 0
            let sublayerToRemove = sublayers[indexToRemove]
            sublayerToRemove.removeFromSuperlayer()
            colorView.layer.sublayers?.remove(at: indexToRemove)
        }
        self.colorView.layer.insertSublayer(gradient, at: 0)
    }
}

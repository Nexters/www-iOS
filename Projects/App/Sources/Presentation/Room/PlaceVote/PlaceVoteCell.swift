//
//  PlaceVoteCell.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/21.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

enum PlaceVoteCellStatus {
    case progSelected
    case progNotSelected
    case doneSelected
    case doneNotSelected
    //    case comfirm
}

final class PlaceVoteCell: UITableViewCell {
    // MARK: - Properties
    
    static let id = "PlaceVoteCell"
    
    private var isClicked = false
    private var isGradient = false
    
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
    
    private let badgeView: UIImageView = {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.wwwColor(.WWWGreen)
        let img = UIImage(named: "check")
        $0.contentMode = .scaleAspectFit
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let insetsImage = img?.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        $0.image = insetsImage
        return $0
    }(UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24)))
    
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//       super.setSelected(selected, animated: animated)
//        self.onSelected()
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        countLabel.text = "0명"
        setProgress(progress: 0.0)
    }
    
}


// MARK: privates
extension PlaceVoteCell {
    
    func configure(
        isVoted: Bool,
        placevote: PlaceVote,
        total: Int
    ) {
        nameLabel.text = "\(placevote.placeName)"
        countLabel.text = "\(placevote.count)명"
        
        let progress = CGFloat(placevote.count) / CGFloat(total)
        
        if isVoted {
            setProgress(progress: progress)
            setStatus(type: placevote.isMyVote
                      ? .doneSelected
                      : .doneNotSelected)
        } else {
            setProgress(progress: progress)
            setStatus(type: placevote.isMyVote
                      ? .progSelected
                      : .progNotSelected)
        }
    }
    
    private func setStatus(type: PlaceVoteCellStatus) {
        
        switch type {
        case .progSelected:
            containerView.layer.borderWidth = 1.0
            containerView.layer.borderColor = UIColor.wwwColor(.WWWGreen).cgColor
            badgeView.backgroundColor = UIColor.wwwColor(.WWWGreen)
            showBadge()
            setGradient(status: .progSelected)
        case .progNotSelected:
            gradientClear()
            containerView.layer.borderWidth = 0
            hideBadge()
        case .doneSelected:
            badgeView.backgroundColor = .clear
            setGradient(status: type)
            showBadge()
        case .doneNotSelected:
            setGradient(status: type)
            hideBadge()
        }
    }

}



// MARK: - Private Methods
extension PlaceVoteCell {
    
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
        
        self.layoutIfNeeded()
    }
    
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
    
    private func showBadge() {
        
        badgeView.removeFromSuperview()
        nameLabel.removeFromSuperview()
        
        containerView.addSubviews(badgeView, nameLabel)
        
        badgeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(47)
            make.centerY.equalToSuperview()
        }
        
    }
    
    private func hideBadge() {
        badgeView.removeFromSuperview()
        nameLabel.removeFromSuperview()
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setGradient(status: PlaceVoteCellStatus) {
        
        var opacity = 0.0
        switch status {
        case .progSelected: opacity = 0.5
        case .progNotSelected: opacity = 0.0
        case .doneSelected: opacity = 1.0
        case .doneNotSelected: opacity = 0.1
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
    
    private func gradientClear() {
        self.layoutIfNeeded()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.locations = [0.0, 1.0]
        let colors: [CGColor] = [
            UIColor.wwwColor(.Gray200).withAlphaComponent(1.0).cgColor,
            UIColor.wwwColor(.Gray200).withAlphaComponent(1.0).cgColor
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

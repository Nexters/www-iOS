//
//  PlaceVoteCell.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/21.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

enum PlaceVoteCellType {
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
        setUI(progress: 1.0)
        setStatus(type: .doneNotSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
        self.onSelected()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}


// MARK: privates
extension PlaceVoteCell {
    
    func configure(title: String, count: Int) {
        nameLabel.text = title
        countLabel.text = "\(count)명"
    }
    
    func onSelected() {
        isClicked = !isClicked
        manageSelection()
        self.layoutIfNeeded()
    }
    
    private func setStatus(type: PlaceVoteCellType) {
        switch type {
        case .progSelected:
            containerView.layer.borderWidth = 1.0
            containerView.layer.borderColor = UIColor.wwwColor(.WWWGreen).cgColor
            badgeView.backgroundColor = UIColor.wwwColor(.WWWGreen)
            makeGradient(opacity: 0.5)
            showBadge()
        case .progNotSelected:
            containerView.layer.borderWidth = 0
            hideGradient()
            hideBadge()
        case .doneSelected:
            badgeView.backgroundColor = .clear
            makeGradient(opacity:1.0)
            showBadge()
        case .doneNotSelected:
            makeGradient(opacity: 0.1)
            hideBadge()
        }
    }

}



// MARK: - Private Methods
extension PlaceVoteCell {
    
    private func setUI(progress: CGFloat) {
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
        
        container.addSubview(colorView)
        colorView.layer.cornerRadius = 15
        colorView.layer.masksToBounds = true
        hideGradient()
        
        let width = (300.horizontallyAdjusted) * progress // TODO: 계산이상하게 안맞음
        
        containerView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(300.horizontallyAdjusted)
            make.height.equalTo(48.verticallyAdjusted)
        }
        
        containerView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(nameLabel)
        
    }
    
    private func manageSelection(){
        if isSelected {
            UIView.animate(withDuration: 0.1) {
                self.setStatus(type: .doneSelected)
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.setStatus(type: .doneNotSelected)
            }
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
    
    
    private func makeGradient(opacity: CGFloat) {
        colorView.backgroundColor = .clear
        colorView.addGradientLayer(colors: [UIColor.wwwColor(.WWWMint).withAlphaComponent(opacity).cgColor,
                                            UIColor.wwwColor(.WWWGreen).withAlphaComponent(opacity).cgColor],
                                   locations: nil,
                                   startPoint: CGPoint(x: 0, y: 0.5),
                                   endPoint: CGPoint(x: 1, y: 0.5))
        // TODO: 버튼 막아서 레이어 더 못쌓이게 해야함! -> 한번더 누르면 해지되도록하면됨!
        self.layoutIfNeeded()
    }
    
    private func hideGradient() {
        isGradient = false
        colorView.backgroundColor = .clear
        colorView.backgroundColor = .wwwColor(.Gray200)
        self.layoutIfNeeded()
    }
    
//    private func setProgress(progress: CGFloat) {
//        let width = self.contentView.bounds.width - 10 * progress
//        containerView.addSubview(colorView)
//        colorView.snp.makeConstraints { make in
//            make.leading.top.equalToSuperview()
//            make.width.equalTo(width)
//            make.height.equalTo(48)
//        }
//        self.layoutIfNeeded()
//    }
//
}

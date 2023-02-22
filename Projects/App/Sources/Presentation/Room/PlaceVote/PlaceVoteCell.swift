//
//  PlaceVoteCell.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/21.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

final class PlaceVoteCell: UITableViewCell {
    // MARK: - Properties
    
    static let id = "PlaceVoteCell"
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let containerView: UIView = {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .wwwColor(.Gray100)
        return $0
    }(UIView())
    
    private let colorView = UIView()
    
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
        setUI(progress: 0.5)
        makeGradient(isSelected: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setUI(progress: CGFloat) {
        contentView.addSubviews(containerView, colorView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20))
            make.height.equalTo(48)
        }
        
        containerView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(48)
        }
        
        setProgress(progress: progress)

        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func setProgress(progress: CGFloat) {
        let width = self.contentView.bounds.width * progress
        containerView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(48)
        }
        self.layoutIfNeeded()
    }
    
    func configure(with text: String) {
        nameLabel.text = "\(text)번째"
    }
    
    private func makeGradient(isSelected: Bool) {
        colorView.layer.cornerRadius = 15
        colorView.layer.masksToBounds = true
        colorView.addGradientLayer(colors: [UIColor.wwwColor(.WWWMint).withAlphaComponent(isSelected ? 1.0 : 0.2).cgColor,
                                            UIColor.wwwColor(.WWWGreen).withAlphaComponent(isSelected ? 1.0 : 0.2).cgColor],
                                   locations: nil,
                                   startPoint: CGPoint(x: 0, y: 0.5),
                                   endPoint: CGPoint(x: 1, y: 0.5))
        self.layoutIfNeeded()
    }
    
    
    
}


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
    
    private let gradientLayer = CAGradientLayer()
    private let containerView = UIView()
    private let nameLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20))
            make.height.equalTo(48)
        }
        
        containerView.addSubview(nameLabel)
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        gradientLayer.colors = [
            UIColor(red: 0.255, green: 0.887, blue: 0.621, alpha: 1).cgColor,
            UIColor(red: 0.409, green: 0.892, blue: 0.805, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 0.84]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 0.294, green: 0.89, blue: 0.667, alpha: 1).cgColor
    }
    
    func configure(with text: String) {
        textLabel?.text = text
    }
    
}


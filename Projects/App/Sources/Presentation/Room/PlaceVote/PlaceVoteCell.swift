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
    
    private let containerView: UIView = {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .wwwColor(.Gray100)
        return $0
    }(UIView())
    
    private let colorView = UIView()
    private let nameLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        makeGradient(isSelected: true)
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
        
        containerView.addSubview(colorView)
        
        colorView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(48)
        }
        
        containerView.addSubview(nameLabel)
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
    
    func configure(with text: String) {
        textLabel?.text = text
    }
    
    
    private func makeGradient(isSelected: Bool) {
        self.layoutIfNeeded()
        colorView.layer.cornerRadius = 15
        colorView.layer.masksToBounds = true
        colorView.addGradientLayer(colors: [UIColor.wwwColor(.WWWMint).withAlphaComponent(isSelected ? 1.0 : 0.2).cgColor,
                                            UIColor.wwwColor(.WWWGreen).withAlphaComponent(isSelected ? 1.0 : 0.2).cgColor],
                                   locations: nil,
                                   startPoint: CGPoint(x: 0, y: 0.5),
                                   endPoint: CGPoint(x: 1, y: 0.5))
    }
    
}


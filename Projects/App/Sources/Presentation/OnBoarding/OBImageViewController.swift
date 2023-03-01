//
//  OBFirstViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

class OBImageViewController: UIViewController {
    
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    init(imageName: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension OBImageViewController {
    
    private func setUI() {
        view.addSubviews(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalTo(375.horizontallyAdjusted)
            $0.height.equalTo(664.verticallyAdjusted)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

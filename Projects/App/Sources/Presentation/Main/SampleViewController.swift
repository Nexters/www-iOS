//
//  ViewController.swift
//  www
//
//  Created by Chanhee Jeong on 2023/01/31.
//

import UIKit
import SnapKit


class SampleViewController: UIViewController {

    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        label.text = "테스트"
        label.font = UIFont.www.title1
//        label.font = UIFont.www(size: 30, family: .Bold)
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
    }

}


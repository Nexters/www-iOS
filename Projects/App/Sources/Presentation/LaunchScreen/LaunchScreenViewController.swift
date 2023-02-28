//
//  LaunchScreenViewController.swift
//  App
//
//  Created by kokojong on 2023/02/28.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import RxSwift

final class LaunchScreenViewController: UIViewController {
    
    private let launchImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(.union2)
        img.contentMode = .scaleAspectFit
        img.snp.makeConstraints {
            $0.width.equalTo(180.horizontallyAdjusted)
        }
        return img
    }()
    
    private var viewModel: LaunchScreenViewModel
    
    private var bag = DisposeBag()
    
    init(viewModel: LaunchScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        fetchJWTToken()
    }
    
    private func setUI() {
        self.view.backgroundColor = .wwwColor(.WWWWhite)
        view.addSubview(launchImg)
        launchImg.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(240.verticallyAdjusted)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func fetchJWTToken() {
        viewModel.transform(input: LaunchScreenViewModel.Input(viewDidLoad: Observable<Void>.just(())), disposeBag: bag)
    }
}


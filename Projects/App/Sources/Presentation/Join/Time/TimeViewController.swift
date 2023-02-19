//
//  TimeViewController.swift
//  AppTests
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class TimeViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
//    var viewModel: TimeViewModel?
    
    private let progressView = ProgressView(current: 3, total: 4)
    
    private let titleView = BasicTitleView(title: "가능한 시간대를 선택해주세요.",
                                           subTitle: "2월 21일 (화) - 3월 3일 (금)")
    
    private let dateView = DateStackView()
    
    private let timeView = TimeStackView()
    
    private let line: UIView = {
        $0.backgroundColor = .wwwColor(.Gray150)
        return $0
    }(UIView())
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("다음", for: .normal)
        return $0
    }(LargeButton(state: false))
    
    // MARK: - LifeCycle
    init() {
//        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Function

extension TimeViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        self.view.addSubview(dateView)
        dateView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(44.verticallyAdjusted)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(line)
        line.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(dateView.snp.bottom)
        }
        
        self.view.addSubview(timeView)
        timeView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(16.verticallyAdjusted)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(59.horizontallyAdjusted)
            $0.height.equalTo(276.verticallyAdjusted)
        }
        
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    /* Temp */
    private func setNavigationBar(title: String = "") {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(.chevron_left), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .black
        let progressLabel = UILabel()
        progressLabel.text = "3/4"
        progressLabel.font = UIFont.www.body3
        let progressItem: UIBarButtonItem = UIBarButtonItem(customView: progressLabel)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = progressItem
        navigationItem.title = title
    }
    
    @objc func backButtonDidTap() {}
    
}

// MARK: - Binding
private extension TimeViewController {

}


// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TimeViewController_Preview: PreviewProvider {
    static var previews: some View {
        TimeViewController().toPreview()
    }
}
#endif


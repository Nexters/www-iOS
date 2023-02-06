//
//  RoomNameViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/07.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit

final class RoomNameViewController: UIViewController {
    
//    public var titleLabel = UILabel()
//    public var subtitleLabel = UILabel()
//    private let titleStackView = UIStackView()
    
    // MARK: - Properties
    
    private let progressView = ProgressView(current: 1, total: 6)
    private let progressLabel = UILabel()
    
    private let titleView = BasicTitleView(title: "약속방의\n이름을 알려주세요.")
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("다음", for: .normal)
        $0.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return $0
    }(LargeButton(state: true))

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
        setNavigationBar()
    }
    

}

// MARK: - Binding
extension RoomNameViewController {
    
    
}

// MARK: - Function

extension RoomNameViewController {
    
    private func attributes() {
        self.view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubviews(nextButton, titleView, progressView)
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setNavigationBar() {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .black
        progressLabel.text = "1/6"
        let progressItem: UIBarButtonItem = UIBarButtonItem(customView: progressLabel)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = progressItem
        navigationItem.title = "넥스터즈 뒷풀이"
    }
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonDidTap() {
//        input.send(.nextButtonDidTap)
        print("다음버튼이 눌렸어요!")
    }
    
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct RoomNameViewController_Preview: PreviewProvider {
    static var previews: some View {
        RoomNameViewController().toPreview()
    }
}
#endif

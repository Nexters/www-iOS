//
//  RoomNameViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/07.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class RoomNameViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private let progressView = ProgressView(current: 1, total: 6)
    
    private let titleView = BasicTitleView(title: "약속방의\n이름을 알려주세요.")
    
    private lazy var textFieldView = BasicTextFieldView(placeholder: "약속방 이름 입력")
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Binding
extension RoomNameViewController {
    private func bind() {
        textFieldView.textField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { [weak self] in
                self?.textFieldView.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Function

extension RoomNameViewController {
    
    private func attributes() {
        self.view.backgroundColor = .white
        textFieldView.textField.becomeFirstResponder()
    }
    
    private func layout() {
        view.addSubviews(nextButton, titleView, progressView, textFieldView)
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).inset(-32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
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
        progressLabel.text = "1/6"
        progressLabel.font = UIFont.www.body3
        let progressItem: UIBarButtonItem = UIBarButtonItem(customView: progressLabel)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = progressItem
        navigationItem.title = title
    }
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonDidTap() {
        textFieldView.setErrorMode(message: "에러메세지도 나와요")
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

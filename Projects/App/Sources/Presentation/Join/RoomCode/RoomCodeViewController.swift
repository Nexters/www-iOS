//
//  UserNameViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class RoomCodeController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var viewModel: RoomCodeViewModel?
    
    private let progressView = ProgressView(current: 1, total: 4)
    
    private let titleView = BasicTitleView(title: "친구에게 받은\n참여 코드를 입력해주세요.")
    
    private lazy var textFieldView = BasicTextFieldView(placeholder: "참여 코드 입력")
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("다음", for: .normal)
        return $0
    }(LargeButton(state: false))
    
    // MARK: - LifeCycle
    init(viewModel: RoomCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Function

extension RoomCodeController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        textFieldView.textField.becomeFirstResponder()
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        self.view.addSubview(textFieldView)
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).inset(-32)
            $0.leading.trailing.equalToSuperview().inset(20)
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
        progressLabel.text = "1/4"
        progressLabel.font = UIFont.www.body3
        let progressItem: UIBarButtonItem = UIBarButtonItem(customView: progressLabel)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = progressItem
        navigationItem.title = title
    }
    
    @objc func backButtonDidTap() {}
    
}

// MARK: - Binding
private extension RoomCodeController {
    func bindViewModel() {
        let input = RoomCodeViewModel.Input(
            codeTextFieldDidEdit:
                textFieldView.textField.rx.text.orEmpty.asObservable(),
            nextButtonDidTap:
                self.nextButton.rx.tap.asObservable(),
            backButtonDidTap:
                self.navigationItem.leftBarButtonItem!.rx.tap.asObservable()
        )
        
        let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag)
        
        self.bindPager(output: output)
        
        output?.nextButtonMakeEnable
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isEnabled in
                if isEnabled == true {
                    self?.nextButton.setButtonState(true)
                } else {
                    self?.nextButton.setButtonState(false)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindPager(output: RoomCodeViewModel.Output?){
        output?.navigatePage
            .asDriver(onErrorJustReturn: .error)
            .drive(onNext: { [weak self] page in
                switch page {
                case .back:
                    self?.navigationController?.popViewController(animated: true)
                case .nickName:
                    // VM에서 코드 검증 단계
                    let viewModel = UserNameViewModel(joinGuestUseCase: JoinGuestUseCase())
                    self?.navigationController?.pushViewController(UserNameViewController(viewModel: viewModel, userMode: .guest), animated: true)
                case .error: break
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct RoomCodeController_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = RoomCodeViewModel(joinGuestUseCase: JoinGuestUseCase())
        RoomCodeController(viewModel: viewModel).toPreview()
    }
}
#endif

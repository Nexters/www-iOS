//
//  RoomNameViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/07.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class RoomNameViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel: RoomNameViewModel
    
    private let progressView = ProgressView(current: 1, total: 6)
    
    private let titleView = BasicTitleView(title: "약속방의\n이름을 알려주세요.")
    
    private lazy var titleImgView: UIImageView = {
        $0.image = UIImage(.bubble)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var textFieldView = BasicTextFieldView(placeholder: "약속방 이름 입력")
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("다음", for: .normal)
        return $0
    }(LargeButton(state: false))
    
    // MARK: - LifeCycle
    init(viewModel: RoomNameViewModel) {
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
        bindUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Function

extension RoomNameViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        textFieldView.textField.becomeFirstResponder()
        
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
            $0.height.equalTo(110)
        }
        
        self.view.addSubview(titleImgView)
        titleImgView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(28)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(92.horizontallyAdjusted)
            $0.height.equalTo(77.verticallyAdjusted)
        }
        
        self.view.addSubview(textFieldView)
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(32)
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
        progressLabel.text = "1/6"
        progressLabel.font = UIFont.www.body3
        let progressItem: UIBarButtonItem = UIBarButtonItem(customView: progressLabel)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = progressItem
        navigationItem.title = title
    }
    
    @objc func backButtonDidTap() {}
    
}

// MARK: - Binding
private extension RoomNameViewController {
    
    func bindUI() {
        textFieldView.textField.rx.text.orEmpty
            .map(checkTextValidation(_:))
            .subscribe(onNext: { [weak self] e in
                switch e {
                case .over:
                    self?.textFieldView.setErrorMode(message: "최대 12자 이내로 작성해 주세요.")
                case .under:
                    self?.textFieldView.setNormalMode()
                case .normal:
                    self?.textFieldView.setNormalMode()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func checkTextValidation(_ input: String) -> TextInputError {
        if input.count > 12 {
            let index = input.index(input.startIndex, offsetBy: 12)
            self.textFieldView.textField.text = String(input[..<index])
            return .over
        }
        if input.count < 2 {
            return .under
        }
        return .normal
    }
    
    func bindViewModel() {
        let input = RoomNameViewModel.Input(
            roomNameTextFieldDidEdit:
                textFieldView.textField.rx.text.orEmpty.asObservable(),
            nextButtonDidTap:
                self.nextButton.rx.tap.asObservable(),
            backButtonDidTap:
                self.navigationItem.leftBarButtonItem!.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(input: input, disposeBag: self.disposeBag)
        
        self.bindPager(output: output)
        
        output.nextButtonMakeEnable
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isEnabled in
                self?.nextButton.setButtonState(isEnabled)
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindPager(output: RoomNameViewModel.Output?){
        output?.navigatePage
            .asDriver(onErrorJustReturn: .error)
            .drive(onNext: { [weak self] page in
                switch page {
                case .back:
                    self?.navigationController?.popViewController(animated: true)
                case .nickName:
                    self?.view.endEditing(true)
                    self?.textFieldView.textField.resignFirstResponder()
                    let viewModel = UserNameViewModel(joinHostUseCase: self!.viewModel.getUseCase())
                    self?.navigationController?.pushViewController(UserNameViewController(viewModel: viewModel, userMode: .host), animated: true)
                case .error: break
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct RoomNameViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        let viewModel = RoomNameViewModel(joinAdminUseCase: JoinHostUseCase())
//        RoomNameViewController(viewModel: viewModel).toPreview()
//    }
//}
#endif

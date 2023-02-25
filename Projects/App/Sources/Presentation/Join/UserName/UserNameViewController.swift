//
//  UserNameViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class UserNameViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel: UserNameViewModel?
    private let userMode: UserType
    
    private let progressView = ProgressView(current: 0, total: 0)
    
    private let titleView = BasicTitleView(title: "약속방에서 사용하실\n닉네임을 알려주세요.")
    
    private lazy var textFieldView = BasicTextFieldView(placeholder: "닉네임 입력")
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("다음", for: .normal)
        return $0
    }(LargeButton(state: false))
    
    
    // Navigation Items
    private let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(.chevron_left), style: .plain, target: UserNameViewController.self, action: #selector(backButtonDidTap))
    
    private let progressLabel = UILabel()

    
    // MARK: - LifeCycle
    init(viewModel: UserNameViewModel, userMode: UserType) {
        self.viewModel = viewModel
        self.userMode = userMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFieldView.textField.becomeFirstResponder()
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

extension UserNameViewController {
    
    private func setUI() {
        
        self.view.backgroundColor = .white
//        textFieldView.textField.becomeFirstResponder()
        
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
    private func setNavigationBar(title: String = "", step: String = "") {
        backButton.tintColor = .black
        progressLabel.text = step
        progressLabel.font = UIFont.www.body3
        let progressItem: UIBarButtonItem = UIBarButtonItem(customView: progressLabel)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = progressItem
        navigationItem.title = title
    }
    
    @objc func backButtonDidTap() {}
    
}

// MARK: - Binding
private extension UserNameViewController {
    func bindViewModel() {
        let input = UserNameViewModel.Input(
            viewDidLoad:
                Observable.just(()).asObservable(),
            userNameDidEdit:
                textFieldView.textField.rx.text.orEmpty.asObservable(),
            nextButtonDidTap:
                self.nextButton.rx.tap.asObservable(),
            backButtonDidTap:
                self.navigationItem.leftBarButtonItem!.rx.tap.asObservable()
        )
        
        let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag)
        
        self.bindPager(output: output)
        
        output?.naviTitleText
            .asDriver()
            .drive(onNext: { [weak self] title in
                switch self?.userMode {
                case .host:
                    self?.progressView.setProgress(current: 2, total: 6)
                    self?.setNavigationBar(title: title, step: "2/6")
                case .guest:
                    self?.progressView.setProgress(current: 2, total: 4)
                    self?.setNavigationBar(title: title, step: "2/4")
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
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
    
    func bindPager(output: UserNameViewModel.Output?){
        output?.navigatePage
            .asDriver(onErrorJustReturn: .error)
            .drive(onNext: { [weak self] page in
                switch page {
                case .back:
                    self?.navigationController?.popViewController(animated: true)
                case .minUser:
                    self?.view.endEditing(true)
                    self?.textFieldView.textField.resignFirstResponder()
                    let viewmodel = MinUserViewModel(joinAdminUseCase: self?.viewModel?.getHostUseCase() ?? JoinHostUseCase())
                    self?.navigationController?.pushViewController(MinUserViewController(viewModel: viewmodel), animated: true)
                case .timeslot:
                    self?.view.endEditing(true)
                    self?.textFieldView.textField.resignFirstResponder()
                    let viewmodel = TimeViewModel(joinGuestUseCase: self?.viewModel?.getGuestUseCase())
                    self?.navigationController?.pushViewController(TimeViewController(viewmodel: viewmodel, userMode: .guest), animated: true)
                case .error: break
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct UserNameViewController_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = UserNameViewModel(joinGuestUseCase: JoinGuestUseCase(), joinHostUseCase: nil)
        UserNameViewController(viewModel: viewModel, userMode: .host).toPreview()
    }
}
#endif

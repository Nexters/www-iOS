//
//  MinUserViewController.swift
//  AppTests
//
//  Created by Chanhee Jeong on 2023/02/11.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class MinUserViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var viewModel: MinUserViewModel?
    
    private let progressView = ProgressView(current: 1, total: 6)
    
    private let stepperView = Stepper(viewData: StepperViewData(color: .black,
                                                            minimum: 1.0,
                                                            maximum: 20.0,
                                                            stepValue: 1.0))
    
    private let titleView = BasicTitleView(title: "최소 인원을 설정해 주세요.",
                                           subTitle: "최소 인원 입장 완료 시, 투표가 시작됩니다.")
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("다음", for: .normal)
        return $0
    }(LargeButton(state: false))
    
    // MARK: - LifeCycle
    init(viewModel: MinUserViewModel) {
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

extension MinUserViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        
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
        
        self.view.addSubview(stepperView)
        stepperView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(132)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(104)
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
private extension MinUserViewController {
    func bindViewModel() {
        let input = MinUserViewModel.Input(
//            roomNameTextFieldDidEdit:
//                textFieldView.textField.rx.text.orEmpty.asObservable(),
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
                self?.nextButton.setButtonState(isEnabled)
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindPager(output: MinUserViewModel.Output?){
        output?.navigatePage
            .asDriver(onErrorJustReturn: .error)
            .drive(onNext: { [weak self] page in
                switch page {
                case .back:
                    self?.navigationController?.popViewController(animated: true)
                case .calendar:
                    print("달력뷰로!")
                case .error: break
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MinUserViewController_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = MinUserViewModel(joinAdminUseCase: JoinHostUseCase())
        MinUserViewController(viewModel: viewModel).toPreview()
    }
}
#endif

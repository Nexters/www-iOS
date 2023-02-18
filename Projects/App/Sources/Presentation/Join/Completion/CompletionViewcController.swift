//
//  CompletionViewcController.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/18.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class CompletionViewcController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var viewModel: CompletionViewModel?

    public lazy var subTitleLabel: UILabel = {
        $0.text = "함께할 친구들을 초대해 보세요."
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = UIColor.wwwColor(.Gray500)
        $0.font = .www.title9
        return $0
    }(UILabel())
    
    public lazy var titleLabel: UILabel = {
        $0.text = "약속방 만들기가 완료되었어요!"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = UIColor.wwwColor(.WWWBlack)
        $0.font = .www.title2
        return $0
    }(UILabel())
    
    public lazy var highlightView: UIView = {
        $0.backgroundColor = .wwwColor(.WWWGreen).withAlphaComponent(0.2)
        return $0
    }(UIView())
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("약속방으로 가기", for: .normal)
        $0.setButtonState(true)
        return $0
    }(LargeButton(state: false))
    
    
    // MARK: - LifeCycle
    init(viewModel: CompletionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Function

extension CompletionViewcController {
    
    private func setUI() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(highlightView)
        highlightView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.equalTo(128)
            make.height.equalTo(10)
        }

        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc func backButtonDidTap() {}
    
}

// MARK: - Binding
private extension CompletionViewcController {
    func bindViewModel() {
        let input = CompletionViewModel.Input(
            viewDidLoad:
                Observable.just(()).asObservable(),
            nextButtonDidTap:
                self.nextButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag)
        
        self.bindPager(output: output)
        
    }
    
    func bindPager(output: CompletionViewModel.Output?){
        output?.navigatePage
            .asDriver(onErrorJustReturn: .error)
            .drive(onNext: { page in
                switch page {
                case .roomMain: print("룸메인으로")
                case .error: break
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CompletionViewcController_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = CompletionViewModel(usecase: JoinHostUseCase())
        CompletionViewcController(viewModel: viewModel).toPreview()
    }
}
#endif

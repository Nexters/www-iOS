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
    
    private let hapticGenerator = UINotificationFeedbackGenerator()
    private lazy var motionGenerator = WWWAnimationHelper()

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
    
//    private lazy var imageView: UIImageView = {
//        $0.image = UIImage(.completion)
//        $0.contentMode = .scaleAspectFit
//        return $0
//    }(UIImageView())
    
    private lazy var imageView: UIImageView = {
        $0.image = UIImage(.monster)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var donutView: UIImageView = {
        $0.image = UIImage(.donut)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var heartView: UIImageView = {
        $0.image = UIImage(.heart_big)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var miniHeartView: UIImageView = {
        $0.image = UIImage(.heart_small)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    

    private let copyButton: UIButton = {
        $0.titleLabel?.adjustsFontForContentSizeCategory = true
        $0.setImage(UIImage(.link_green), for: .normal)
        $0.layer.borderColor = UIColor.wwwColor(.Gray200).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 21
        $0.setTitle(" 링크 복사하기", for: .normal)
        $0.setTitleColor(.wwwColor(.WWWBlack).withAlphaComponent(0.7), for: .highlighted)
        $0.titleLabel?.font = .www.body3
        $0.setTitleColor(.wwwColor(.WWWBlack), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .center
        return $0
    }(UIButton())
    
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
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

        self.view.bringSubviewToFront(titleLabel)
        
        
        self.view.addSubviews(imageView, donutView, heartView, miniHeartView)
        self.view.bringSubviewToFront(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(278)
            make.height.equalTo(246)
        }
        
        donutView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(178)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(143)
            make.height.equalTo(126)
        }
        
        heartView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(96)
            make.trailing.equalToSuperview().offset(-55)
            make.width.equalTo(44)
            make.height.equalTo(45)
        }
        
        miniHeartView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(88)
            make.trailing.equalToSuperview().offset(-32)
            make.width.equalTo(21.8)
            make.height.equalTo(20.65)
        }
        
        
        self.view.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(55) // TODO : 35
            make.centerX.equalToSuperview()
            make.width.equalTo(137)
            make.height.equalTo(42)
        }
        
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setMotion() {
        motionGenerator.applyParallaxEffect(to: imageView, magnitue: -30)
        motionGenerator.applyParallaxEffect(to: donutView, magnitue: 30)
        motionGenerator.applyParallaxEffect(to: heartView, magnitue: -30)
        motionGenerator.applyParallaxEffect(to: miniHeartView, magnitue: 30)
    }
    
}

// MARK: - Binding
private extension CompletionViewcController {
    func bindViewModel() {
        let input = CompletionViewModel.Input(
            viewDidLoad:
                Observable.just(()).asObservable(),
            copyButtonDidTap:
                self.copyButton.rx.tap.asObservable(),
            nextButtonDidTap:
                self.nextButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag)
        
        output?.copiedRoomInfo
            .asDriver()
            .drive(onNext: { [weak self] text in
                self?.hapticGenerator.notificationOccurred(.success)
            })
            .disposed(by: disposeBag)
        
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

//
//  UserNameViewModel.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxCocoa
import RxSwift

enum UserNamePager {
    case back
    case calendar
    case timeslot
    case error
}

final class UserNameViewModel: BaseViewModel {
    
    // MARK: - Properties
    private let usecase: JoinGuestUseCase
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let userNameDidEdit: Observable<String>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var naviTitleText = BehaviorRelay<String>(value: "")
        var roomNameTextFieldText = BehaviorRelay<String>(value: "")
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<UserNamePager>()
    }
    
    init(joinGuestUseCase: JoinGuestUseCase) {
        self.usecase = joinGuestUseCase
    }

    // MARK: - Transform
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.handleInput(input, disposeBag: disposeBag)
        return makeOutput(with:  input, disposeBag: disposeBag)
    }
    
    private func handleInput(_ input: Input, disposeBag: DisposeBag) {
        input.userNameDidEdit
            .bind(to: self.usecase.userName)
            .disposed(by: disposeBag)
    }
    
    private func makeOutput(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.usecase.userName
            .compactMap { $0 }
            .subscribe(onNext: { userName in
                if userName != "" {
                    output.nextButtonMakeEnable.accept(true)
                } else {
                    output.nextButtonMakeEnable.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.back)
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .subscribe(onNext: {
                output.naviTitleText.accept(self.usecase.roomName)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.timeslot)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}


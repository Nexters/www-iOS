//
//  UserNameViewModel.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxCocoa
import RxSwift

enum RoomCodePager {
    case back
    case nickName
    case error
}

final class RoomCodeViewModel: BaseViewModel {
    
    // MARK: - Properties
    private let usecase: JoinGuestUseCase
    
    struct Input {
        let codeTextFieldDidEdit: Observable<String>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var roomNameTextFieldText = BehaviorRelay<String>(value: "")
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<RoomCodePager>()
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
        input.codeTextFieldDidEdit
            .bind(to: self.usecase.roomCode)
            .disposed(by: disposeBag)
    }
    
    private func makeOutput(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.usecase.roomCode
            .compactMap { $0 }
            .subscribe(onNext: { roomname in
                if roomname != "" {
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
        
        input.nextButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.nickName)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

//
//  UserNameViewModel.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxRelay
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
    
    func getUseCase() -> JoinGuestUseCase {
        return self.usecase
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
                output.nextButtonMakeEnable.accept(roomname != "" ? true : false)
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

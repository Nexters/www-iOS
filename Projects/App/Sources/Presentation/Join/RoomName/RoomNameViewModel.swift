//
//  RoomNameViewModel.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/07.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxRelay
import RxSwift

enum RoomNamePager {
    case back
    case nickName
    case error
}

final class RoomNameViewModel: BaseViewModel {
    
    // MARK: - Properties
    private let usecase: JoinHostUseCase
    
    struct Input {
        let roomNameTextFieldDidEdit: Observable<String>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<RoomNamePager>()
    }
    
    init(joinAdminUseCase: JoinHostUseCase) {
        self.usecase = joinAdminUseCase
    }

    // MARK: - Transform
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.handleInput(input, disposeBag: disposeBag)
        return makeOutput(with:  input, disposeBag: disposeBag)
    }
    
    func getUseCase() -> JoinHostUseCase {
        return self.usecase
    }
    
    private func handleInput(_ input: Input, disposeBag: DisposeBag) {
        input.roomNameTextFieldDidEdit
            .bind(to: self.usecase.roomName)
            .disposed(by: disposeBag)
    }
    
    private func makeOutput(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.usecase.roomName
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
                self.usecase.postMeeting()
                output.navigatePage.accept(.nickName)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

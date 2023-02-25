//
//  TimeViewModel.swift
//  AppTests
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum TimePager {
    case back
    case place
    case error
}

final class TimeViewModel: BaseViewModel {
    
    // MARK: - Properties
    private let usecase: JoinHostUseCase
    
    struct Input {
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<TimePager>()
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

    }
    
    private func makeOutput(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.backButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.back)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .subscribe(onNext: {
                print("연결")
                output.navigatePage.accept(.place)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

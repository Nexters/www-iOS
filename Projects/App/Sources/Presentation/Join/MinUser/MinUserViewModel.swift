//
//  MinUserViewModel.swift
//  AppTests
//
//  Created by Chanhee Jeong on 2023/02/11.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum MinUserPager {
    case back
    case calendar
    case error
}

final class MinUserViewModel: BaseViewModel {
    
    // MARK: - Properties
    private let usecase: JoinHostUseCase
    
    struct Input {
        let plusButtonDidTap: Observable<Void>
        let minusButtonDidTap: Observable<Void>
        let stepperTextDidChange: Observable<String?>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<MinUserPager>()
        var plusValue = PublishRelay<Void>()
        var minusValue = PublishRelay<Void>()
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
        input.stepperTextDidChange
            .map { Int($0!)! }
            .bind(to: self.usecase.minUser)
            .disposed(by: disposeBag)

        input.plusButtonDidTap
            .subscribe(onNext: { [weak self] in
                self?.usecase.updateMinUser(with: 1)
            })
            .disposed(by: disposeBag)
        
        input.minusButtonDidTap
            .subscribe(onNext: { [weak self] in
                self?.usecase.updateMinUser(with: -1)
            })
            .disposed(by: disposeBag)
    }
    
    private func makeOutput(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.usecase.minUser
            .subscribe(onNext: { minUser in
                output.nextButtonMakeEnable.accept(minUser>1)
            })
            .disposed(by: disposeBag)
        
        input.plusButtonDidTap
            .subscribe(onNext: {
                output.plusValue.accept(Void())
            })
            .disposed(by: disposeBag)
        
        input.minusButtonDidTap
            .subscribe(onNext: {
                output.minusValue.accept(Void())
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.back)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.calendar)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

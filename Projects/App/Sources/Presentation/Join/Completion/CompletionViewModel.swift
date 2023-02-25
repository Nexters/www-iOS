//
//  CompletionViewModel.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/18.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxRelay
import Foundation
import RxSwift

enum CompletionPager {
    case roomMain
    case error
}

final class CompletionViewModel: BaseViewModel {
    
    private let usecase: JoinHostUseCase
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let copyButtonDidTap: Observable<Void>
        let nextButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var copiedRoomInfo = PublishRelay<String>()
        var navigatePage = PublishRelay<CompletionPager>()
    }
    
    init(usecase: JoinHostUseCase) {
        self.usecase = usecase
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.handleInput(input, disposeBag: disposeBag)
        return makeOutput(with:  input, disposeBag: disposeBag)
    }
    
    private func handleInput(_ input: Input, disposeBag: DisposeBag) {
        
    }
    
    private func makeOutput(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.nextButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.roomMain)
            })
            .disposed(by: disposeBag)
        
        input.copyButtonDidTap
            .subscribe(onNext: {
                // TODO: 서버통신
                output.copiedRoomInfo.accept("방코드1234가 복사되었어요!")
            })
            .disposed(by: disposeBag)
        
        return output
    }
}


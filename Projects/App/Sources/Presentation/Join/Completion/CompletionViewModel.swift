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
        let nextButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<CompletionPager>()
    }
    
    init(usecase: JoinHostUseCase) {
        self.usecase = usecase
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        return Output.init()
    }
}


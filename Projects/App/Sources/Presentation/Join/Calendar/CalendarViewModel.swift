//
//  CalendarViewModel.swift
//  App
//
//  Created by kokojong on 2023/02/22.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

final class CalendarViewModel: BaseViewModel {
   
//    private let usecase:
    
    enum CalendarPager {
        case back
        case timeView
        case error
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let startDate = BehaviorRelay<String>(value: "")
        let navigatePage = PublishRelay<CalendarPager>()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        input.viewDidLoad.subscribe(onNext: {
            output.startDate.accept("")
        }).disposed(by: disposeBag)
        
        input.backButtonDidTap.subscribe(onNext: {
            output.navigatePage.accept(.back)
        }).disposed(by: disposeBag)
        
        input.nextButtonDidTap.subscribe(onNext: {
            output.navigatePage.accept(.timeView)
        }).disposed(by: disposeBag)
        
        return output
    }
    
}

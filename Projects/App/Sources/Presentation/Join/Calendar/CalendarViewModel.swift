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
   
    private let usecase: JoinHostUseCase
    
    enum CalendarPager {
        case back
        case timeView
        case error
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
        let selectStartDate: BehaviorSubject<Date>
        let selectEndDate: BehaviorSubject<Date>
    }
    
    struct Output {
        let navigatePage = PublishRelay<CalendarPager>()
        let isNextButtonEnable = BehaviorRelay(value: false)
        let toastMessage = PublishRelay<String>()
    }
    
    init(usecase: JoinHostUseCase) {
        self.usecase = usecase
    }
    
    func getUseCase() -> JoinHostUseCase {
        return self.usecase
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        input.selectStartDate
            .bind(to: self.usecase.startDate)
            .disposed(by: disposeBag)
        
        input.selectEndDate
            .bind(to: self.usecase.endDate)
            .disposed(by: disposeBag)
        
        let output = Output()
        
        input.backButtonDidTap.subscribe(onNext: {
            output.navigatePage.accept(.back)
        }).disposed(by: disposeBag)
        
        input.nextButtonDidTap.subscribe(onNext: {
            output.navigatePage.accept(.timeView)
        }).disposed(by: disposeBag)
        
        Observable.zip(input.selectStartDate, input.selectEndDate)
            .subscribe(onNext: { [weak self] start, end in
                let interval = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
                print("start, end", start, end)
                output.isNextButtonEnable.accept(interval < 14 && interval >= 1)
                
                if interval >= 14 {
                    output.toastMessage.accept("14일 이내로 선택할 수 있어요")
                }
                
                if interval < 0 {
                    output.toastMessage.accept("끝 날짜는 시작 날짜 이후로 선택할 수 있어요")
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
}

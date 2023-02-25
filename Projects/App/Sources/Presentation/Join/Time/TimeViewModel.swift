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
    private let usecaseHost: JoinHostUseCase?
    private let usecaseGuest: JoinGuestUseCase?
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var naviTitleText = BehaviorRelay<String>(value: "")
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<TimePager>()
    }
    
    init(joinGuestUseCase: JoinGuestUseCase? = nil, joinHostUseCase: JoinHostUseCase? = nil) {
        self.usecaseGuest = joinGuestUseCase
        self.usecaseHost = joinHostUseCase
    }

    // MARK: - Transform
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.handleInput(input, disposeBag: disposeBag)
        return makeOutput(with:  input, disposeBag: disposeBag)
    }
    
    func getHostUsecase() -> JoinHostUseCase {
        return self.usecaseHost!
    }
    
    func getGeustUsecase() -> JoinGuestUseCase {
        return self.usecaseGuest!
    }
    
    private func handleInput(_ input: Input, disposeBag: DisposeBag) {

    }
    
    private func makeOutput(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                output.naviTitleText.accept((self?.usecaseGuest!.roomName)!)
            })
            .disposed(by: disposeBag)
        
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

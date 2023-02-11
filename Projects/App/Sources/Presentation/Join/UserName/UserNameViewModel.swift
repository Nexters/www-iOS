//
//  UserNameViewModel.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxRelay
import RxSwift

enum UserNamePager {
    case back
    case calendar
    case timeslot
    case error
}

final class UserNameViewModel: BaseViewModel {
    
    // MARK: - Properties
    private let usecaseGuest: JoinGuestUseCase?
    private let usecaseHost: JoinHostUseCase?
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let userNameDidEdit: Observable<String>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var naviTitleText = BehaviorRelay<String>(value: "")
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<UserNamePager>()
    }
    
    init(joinGuestUseCase: JoinGuestUseCase? = nil, joinHostUseCase: JoinHostUseCase? = nil) {
        self.usecaseGuest = joinGuestUseCase
        self.usecaseHost = joinHostUseCase
    }

    // MARK: - Transform
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        if usecaseGuest != nil {
            // Guest
            self.handleInputGuest(input, disposeBag: disposeBag)
            return makeOutputGuest(with: input, disposeBag: disposeBag)
        } else {
            // Host
            self.handleInputHost(input, disposeBag: disposeBag)
            return makeOutputHost(with: input, disposeBag: disposeBag)
        }
    }
}

// MARK: - Guest

extension UserNameViewModel {
    
    private func handleInputGuest(_ input: Input, disposeBag: DisposeBag) {
        input.userNameDidEdit
            .bind(to: self.usecaseGuest!.userName)
            .disposed(by: disposeBag)
    }
    
    private func makeOutputGuest(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.usecaseGuest!.userName
            .compactMap { $0 }
            .subscribe(onNext: { userName in
                output.nextButtonMakeEnable.accept(userName != "" ? true : false)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.back)
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .subscribe(onNext: {
                output.naviTitleText.accept(self.usecaseGuest!.roomName)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.timeslot)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - HOST

extension UserNameViewModel {
    
    private func handleInputHost(_ input: Input, disposeBag: DisposeBag) {
        input.userNameDidEdit
            .bind(to: self.usecaseHost!.userName)
            .disposed(by: disposeBag)
    }
    
    private func makeOutputHost(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.usecaseHost!.userName
            .compactMap { $0 }
            .subscribe(onNext: { userName in
                output.nextButtonMakeEnable.accept(userName != "" ? true : false)
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .subscribe(onNext: {
                guard let roomName = try? self.usecaseHost!.roomName.value() else { return }
                output.naviTitleText.accept(roomName)
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


//
//  SampleViewModel.swift
//  www
//
//  Created by Chanhee Jeong on 2023/02/01.
//

import Foundation
import RxSwift
import RxRelay


final class SampleViewModel: BaseViewModel {
    
    private var bag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Single<Void>
    }
    
    struct Output {
        let loginResult: Single<CommonResponse>
    }

    var disposeBag = DisposeBag()
    
    private let joinUserUseCase: JoinUserUseCase
    
    init(joinUserUseCase: JoinUserUseCase) {
        self.joinUserUseCase = joinUserUseCase
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let loginResult = input.viewDidLoad.flatMap { _ -> Single<CommonResponse> in
            return self.joinUserUseCase.excute(deviceId: "device1", fcmToken: "fcmToken1", userName: "kokojong")
        }
        
        return Output.init(loginResult: loginResult)
    }
}

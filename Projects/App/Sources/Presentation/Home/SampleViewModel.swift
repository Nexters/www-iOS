//
//  SampleViewModel.swift
//  www
//
//  Created by Chanhee Jeong on 2023/02/01.
//

import RxRelay
import Foundation
import RxCocoa
import RxSwift


final class SampleViewModel: BaseViewModel {
    
    private var bag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Single<Void>
    }
    
    struct Output {
        let loginResult: Single<LoginResponseDTO>
    }

    var disposeBag = DisposeBag()
    
    private let joinUserUseCase: JoinUserUseCaseProtocol
    
    init(joinUserUseCase: JoinUserUseCaseProtocol) {
        self.joinUserUseCase = joinUserUseCase
    }

    func transform(input: Input) -> Output {
        let loginResult = input.viewDidLoad.flatMap { _ -> Single<LoginResponseDTO> in
            return self.joinUserUseCase.excute(deviceId: "device1", fcmToken: "fcmToken1", userName: "kokojong")
        }
        
        return Output.init(loginResult: loginResult)
    }
}

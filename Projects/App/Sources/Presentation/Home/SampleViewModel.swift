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
    
    init() {}

    func transform(input: Input) -> Output {
//        let loginResult: BehaviorSubject<LoginResponseDTO> = .SubjectObserverType(value: LoginResponseDTO(code: 200, message: "test", result: Data.init()))
        
        let loginResult = input.viewDidLoad.flatMap { _ -> Single<LoginResponseDTO> in
           return self.joinUser(deviceId: "device1", fcmToken: "fcm1", userName: "kokojong")
               
        }
        
        return Output.init(loginResult: loginResult)
    }
    
    func joinUser(deviceId: String, fcmToken: String, userName: String) -> Single<LoginResponseDTO> {
        let loginRequestDTO = LoginRequestDTO(deviceId: deviceId, fcmToken: fcmToken, userName: userName)
        
        return UserAPIManager.provider.request(.join(param: loginRequestDTO))
            .map(LoginResponseDTO.self)
            .asSingle()
            .do(onSuccess: {
                print("response is",$0)
            }, onError: {
                print("error is",$0)
            })
    }
    
}

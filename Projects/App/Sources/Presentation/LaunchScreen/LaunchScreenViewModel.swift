//
//  LaunchScreenViewModel.swift
//  App
//
//  Created by kokojong on 2023/02/28.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

final class LaunchScreenViewModel: BaseViewModel {
    
    private var bag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    typealias Output = Void
    
    private let joinUserUseCase: JoinUserUseCase
    
    init(joinUserUseCase: JoinUserUseCase) {
        self.joinUserUseCase = joinUserUseCase
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        if UserDefaultKeyCase().getUserToken() == "" {
            
            input.viewDidLoad
                .flatMap { _ in
                    return self.joinUserUseCase.excute(deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "", fcmToken: "", userName: UserDefaultKeyCase().getUserName())
            }
            .subscribe(onNext: { res in
                UserDefaultKeyCase().setUserToken(res.result)
            }).disposed(by: bag)
        }
    }
}

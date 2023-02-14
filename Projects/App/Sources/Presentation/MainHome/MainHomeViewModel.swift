//
//  MainHomeViewModel.swift
//  App
//
//  Created by kokojong on 2023/02/12.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxSwift

final class MainHomeViewModel: BaseViewModel {
    
    private let mainHomeUseCase: MainHomeUseCase?
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        var mainHomeMeeting: Single<MainHomeMeeting>
    }
    
    init(mainHomeUseCase: MainHomeUseCase?) {
        self.mainHomeUseCase = mainHomeUseCase
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let mainHomeMeeting = input.viewDidLoad.asSingle().flatMap {
            _ -> Single<MainHomeMeeting> in
            return self.mainHomeUseCase!.fetchMainHomeMeeting()
        }
        
        return Output(mainHomeMeeting: mainHomeMeeting)
    }
    
    
    
}

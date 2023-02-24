//
//  SettingViewModel.swift
//  App
//
//  Created by kokojong on 2023/02/24.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxSwift
import RxRelay

final class SettingViewModel: BaseViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let togglePushAlarm: Observable<Void>
    }
    
    struct Output {
        let isPushAlarmOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad.subscribe(onNext: {
            output.isPushAlarmOn.accept(UserDefaultKeyCase().getIsPushAlarmOn())
        }).disposed(by: disposeBag)
        
        input.togglePushAlarm.subscribe(onNext: {
            let isPushAlarmOn = !UserDefaultKeyCase().getIsPushAlarmOn()
            UserDefaultKeyCase().setIsPushAlarmOn(isPushAlarmOn)
            output.isPushAlarmOn
                .accept(isPushAlarmOn)
        }).disposed(by: disposeBag)
        
        return output
    }
    
}

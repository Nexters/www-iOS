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
        let togglePushAlarm: Observable<Bool>
    }
    
    struct Output {
        let isPushAlarmOn: PublishRelay<Bool> = PublishRelay<Bool>()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.togglePushAlarm.subscribe(onNext: { isOn in
            UserDefaultKeyCase().setIsPushAlarmOn(isOn)
            output.isPushAlarmOn
                .accept(isOn)
        }).disposed(by: disposeBag)
        
        return output
    }
    
}

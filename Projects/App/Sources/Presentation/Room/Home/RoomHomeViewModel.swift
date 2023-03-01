//
//  RoomMainViewModel.swift
//  App
//
//  Created by kokojong on 2023/02/28.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class RoomMainViewModel: BaseViewModel {
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoad.subscribe(onNext: {
            
        }).disposed(by: disposeBag)
        return
    }

    struct Input {
        let viewDidLoad: Observable<Void>
    }

    typealias Output = Void

}

//
//  RoomParticipantsViewModel.swift
//  App
//
//  Created by kokojong on 2023/02/25.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class RoomParticipantsViewModel: BaseViewModel {
   
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let participants: BehaviorRelay<[User]> = BehaviorRelay(value: []) // TODO: User entity
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        output.participants.accept(User.mockData)
        return output
    }
    
    
}

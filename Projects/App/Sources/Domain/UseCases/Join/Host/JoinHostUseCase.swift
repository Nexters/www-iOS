//
//  JoinAdminUseCase.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift


protocol JoinHostUseCaseProtocol {
    var roomName: BehaviorSubject<String> { get }
    var userName: BehaviorSubject<String> { get }
    var minUser: BehaviorSubject<Int> { get }
}

final class JoinHostUseCase: JoinHostUseCaseProtocol {
    
    // MARK: - Properties
    var roomName = BehaviorSubject<String>(value: "")
    var userName = BehaviorSubject<String>(value: "")
    var minUser = BehaviorSubject<Int>(value: 1)
    
    
    // MARK: - Methods
    init() {}

}

// MARK: - Privates
private extension JoinHostUseCase {
    
}

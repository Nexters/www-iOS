//
//  JoinGuestUseCase.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift


protocol JoinGuestUseCaseProtocol {
    var roomCode: BehaviorSubject<String> { get }
    var roomName: String { get }
    var userName: BehaviorSubject<String> { get }
}

final class JoinGuestUseCase: JoinGuestUseCaseProtocol {
    
    // MARK: - Properties
    var roomCode = BehaviorSubject<String>(value: "")
    var roomName: String = "방이름"
    var userName = BehaviorSubject<String>(value: "")
    
    // MARK: - Methods
    init() {}

    
}

// MARK: - Privates
private extension JoinGuestUseCase {
    
}


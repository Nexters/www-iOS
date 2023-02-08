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
    var nickName: String { get set }
}

final class JoinHostUseCase: JoinHostUseCaseProtocol {
    
    // MARK: - Properties
    var roomName = BehaviorSubject<String>(value: "")
    var nickName: String = ""
    
    
    // MARK: - Methods
    init() {}

    
}

// MARK: - Privates
private extension JoinHostUseCase {
    
}

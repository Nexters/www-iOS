//
//  JoinUserUseCase.swift
//  App
//
//  Created by kokojong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

import RxSwift

protocol JoinUserUseCaseProtocol {
    func excute(deviceId: String, fcmToken: String, userName: String) -> Single<LoginResponseDTO>
}

final class JoinUserUseCase: JoinUserUseCaseProtocol {
    
    // MARK: - Properties
    private let userRepository: UserRepository
    
    // MARK: - Methods
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func excute(deviceId: String, fcmToken: String, userName: String) -> Single<LoginResponseDTO> {
        return self.userRepository.joinUser(deviceId: deviceId, fcmToken: fcmToken, userName: userName)
    }
    
}

// MARK: - Privates
private extension JoinUserUseCaseProtocol {
    
}

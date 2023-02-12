//
//  UserDAO.swift
//  App
//
//  Created by kokojong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxSwift

final class UserDAO: UserRepository {
    
    private let network: RxMoyaProvider<UserAPI>
    
    init(network: RxMoyaProvider<UserAPI>) {
        self.network = network
    }
    
    func joinUser(deviceId: String, fcmToken: String, userName: String) -> RxSwift.Single<CommonResponse> {
        
        return network.request(.join(param: LoginRequestDTO(deviceId: deviceId, fcmToken: fcmToken, userName: userName)))
            .map(LoginResponseDTO.self)
            .map{ $0.toDomain() }
            .asSingle()
            .do(onSuccess: {
                print("response is",$0)
            }, onError: {
                print("error is",$0)
            })
    }
    
    // MARK: - Repositories
    func makeUserRepository() -> UserRepository {
        return UserDAO(network: RxMoyaProvider<UserAPI>())
    }

}

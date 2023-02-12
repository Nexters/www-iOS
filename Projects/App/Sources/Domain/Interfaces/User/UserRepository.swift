//
//  UserRepository.swift
//  App
//
//  Created by kokojong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxSwift

protocol UserRepository {
    func joinUser(deviceId: String, fcmToken: String, userName: String) -> Single<CommonResponse>
}

//
//  LoginRequestDTO.swift
//  www
//
//  Created by kokojong on 2023/02/05.
//

import Foundation

struct LoginRequestDTO: ModelType {
    let deviceId: String
    let fcmToken: String
    let userName: String
}

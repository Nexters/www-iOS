//
//  CustomErrorMapper.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/27.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

enum JoinMeetingError: Error {
    case accessDenied
    case serverError
    case roomDoesntExist
    case userDoesntExist
    case roomAlreadyStarted
    case alreadyInRoom
    case unknown
    
    public var localizedMsg: String {
        switch self {
        case .accessDenied:
            return "접근이 거부되었습니다."
        case .serverError:
            return "서버에서 에러가 발생하였습니다."
        case .roomDoesntExist:
            return "존재하지 않는 약속방 입니다."
        case .userDoesntExist:
            return "존재하지 않는 유저입니다. 앱을 재설치해주세요!"
        case .roomAlreadyStarted:
            return "이미 투표가 시작되어 참가할 수 없습니다."
        case .alreadyInRoom:
            return "이미 참여된 약속방입니다."
        case .unknown:
            return "다시 참여를 시도해주세요."
        }
    }
}

//
//  MeetingAPI.swift
//  App
//
//  Created by kokojong on 2023/02/14.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum MeetingAPI {
    case getMeetings
    case checkMeetingCode(code: String)
    case joinMeeting(meetingId:Int, body: MeetingJoinRequestDTO)
    
}

extension MeetingAPI: TargetType {
    var baseURL: URL {
        return APIConstants.baseUrl
    }
    
    var path: String {
        switch self {
        case .getMeetings:
            return "meetings"
        case .checkMeetingCode(let code):
            return "meetings/code/\(code)"
        case .joinMeeting(let id, _):
            return "meetings/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMeetings:
            return .get
        case .checkMeetingCode:
            return .get
        case .joinMeeting:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMeetings:
            return .requestPlain
        case .checkMeetingCode:
            return .requestPlain
        case .joinMeeting( _, let dto):
            return .requestJSONEncodable(dto)
        }
    }
    
    var headers: [String : String]? {
        // let testToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNjc2ODAzNzQyLCJleHAiOjkyMjMzNzIwMzY4NTQ3NzV9.I_uOzywGtMG0bxX5Yot13103RPHeDfXILhGoDthaBcaMcl26WN7OXp0Hg3u_ksLpZpZtIIt828kj5u7Tgc523Q"
        switch self {
        case .getMeetings:
            return ["Authorization": "Bearer " + UserDefaultKeyCase().getUserToken()]
        case .checkMeetingCode, .joinMeeting:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultKeyCase().getUserToken()]
        }
    }
}

struct MeetingAPIManager {
    static let provider: RxMoyaProvider<MeetingAPI> = MeetingAPI.provider
}

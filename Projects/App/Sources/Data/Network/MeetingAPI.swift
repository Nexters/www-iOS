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
}

extension MeetingAPI: TargetType {
    var baseURL: URL {
        return APIConstants.baseUrl
    }
    
    var path: String {
        switch self {
        case .getMeetings:
            return "meetings"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMeetings:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMeetings:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getMeetings:
            return ["Authorization": "Bearer " + UserDefaultKeyCase().getUserToken()]
        }
    }
}

struct MeetingAPIManager {
    static let provider: RxMoyaProvider<MeetingAPI> = MeetingAPI.provider
}

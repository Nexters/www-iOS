//
//  VoteAPI.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/02.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum VoteAPI {
    case fetchVoteLists(code: MeetingPlaceResponseDTO)
}

extension VoteAPI: TargetType {
    var baseURL: URL {
        return APIConstants.baseUrl
    }
    
    var path: String {
        switch self {
        case .fetchVoteLists(let code):
            return "votes/\(code)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchVoteLists:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchVoteLists(let dto):
            return .requestJSONEncodable(dto)
        }
    }
    
    var headers: [String : String]? {
        // let testToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNjc2ODAzNzQyLCJleHAiOjkyMjMzNzIwMzY4NTQ3NzV9.I_uOzywGtMG0bxX5Yot13103RPHeDfXILhGoDthaBcaMcl26WN7OXp0Hg3u_ksLpZpZtIIt828kj5u7Tgc523Q"
        switch self {
        case .fetchVoteLists:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultKeyCase().getUserToken()]
        }
    }
}

struct VoteAPIManager {
    static let provider: RxMoyaProvider<VoteAPI> = VoteAPI.provider
}

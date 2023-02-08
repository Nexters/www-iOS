//
//  Sample.swift
//  www
//
//  Created by Chanhee Jeong on 2023/02/01.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum UserAPI {
    case join(param: LoginRequestDTO)
}


extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://alpha-api.whenwheres.com:8080/users/")!
    }
    
    var path: String {
        switch self {
        case .join:
            return "join"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .join(let param):
            return .requestParameters(parameters: try! param.asDictionary(), encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .join:
            return nil
        }
    }
    
}

struct UserAPIManager {
    static let provider = RxMoyaProvider<UserAPI>()
}

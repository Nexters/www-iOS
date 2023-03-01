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
    case fetchVoteLists(id: Int)
    case fetchVotePlaces(id: Int) // 유저들이 선택한 장소
    case postVote(id: Int, dto: PlaceVoteRequestDTO)
}

extension VoteAPI: TargetType {
    var baseURL: URL {
        return APIConstants.baseUrl
    }
    
    var path: String {
        switch self {
        case .fetchVoteLists(let id):
            return "votes/\(id)"
        case .fetchVotePlaces(let id):
            return "places/\(id)"
        case .postVote(let id, _):
            return "meetings/\(id)/votes"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchVoteLists:
            return .get
        case .fetchVotePlaces:
            return .get
        case .postVote:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchVoteLists:
            return .requestPlain
        case .fetchVotePlaces:
            return .requestPlain
        case .postVote( _ , let dto):
            return .requestJSONEncodable(dto)
        }
    }
    
    var headers: [String : String]? {
         let testToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzZGxrZGxrZmxramRma2wiLCJpYXQiOjE2Nzc3MTQ0NjUsImV4cCI6OTIyMzM3MjAzNjg1NDc3NX0.DjOvNwKRbyfUd_qwsZbpo3WOzmGW0UFzkTA_0PpKngfDjV2mAcunlZbdemnmb3IoKgBso_cNY8TlaOWISFmZIA"
        switch self {
        case .fetchVoteLists, .fetchVotePlaces, .postVote:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + testToken]
//            return ["Content-Type": "application/json",
//                    "Authorization": "Bearer " + UserDefaultKeyCase().getUserToken()]
        }
    }
}

struct VoteAPIManager {
    static let provider: RxMoyaProvider<VoteAPI> = VoteAPI.provider
}

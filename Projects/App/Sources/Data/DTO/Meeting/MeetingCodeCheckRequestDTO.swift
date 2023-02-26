//
//  MeetingCodeCheckRequest.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/27.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct MeetingCodeCheckRequest: Codable {
    let code: Int
    let message: String
    let result: Result
}


extension MeetingCodeCheckRequest {
    // MARK: - Result
    struct Result: Codable {
        let meetingID: Int
        let meetingName: String
        let minimumAlertMembers: Int
        let hostName: String
        let currentUserName: String
        let isHost: Bool
        let joinedUserCount, votingUserCount: Int
        let meetingCode: String
        let shortLink: String
        let confirmedDate: String?
        let confirmedTime: PromiseTime?
        let confirmedPlace: String?
        let isJoined: Bool
        let startDate, endDate: String
        let joinedUserInfoList: [UserInfoList]
        let userPromiseDateTimeList: [UserPromiseDateTimeList]
        let userPromisePlaceList: [UserPromisePlaceList]
        let meetingStatus: String
        let userVoteList: [UserVoteList]
        
        enum CodingKeys: String, CodingKey {
            case meetingID = "meetingId"
            case meetingName, minimumAlertMembers, hostName, currentUserName, isHost, joinedUserCount, votingUserCount, meetingCode, shortLink, confirmedDate, confirmedTime, confirmedPlace, isJoined, startDate, endDate, joinedUserInfoList, userPromiseDateTimeList, userPromisePlaceList, meetingStatus, userVoteList
        }
    }
    
    // MARK: - UserInfoList
    struct UserInfoList: Codable {
        let joinedUserName: String
        let characterType: String
    }
        
    // MARK: - UserPromiseDateTimeList
    struct UserPromiseDateTimeList: Codable {
        let promiseDate: String
        let promiseTime: PromiseTime
        let promiseDayOfWeek: String
        let userInfoList: [UserInfoList]
    }
    
    // MARK: - UserPromisePlaceList
    struct UserPromisePlaceList: Codable {
        let userName: String
        let userCharacter: String
        let promisePlace: String
    }
        
    
    // MARK: - UserVoteList
    
    struct UserVoteList: Codable {
        var userVoteList: [VoteDTO]
    }

    struct VoteDTO: Codable {
        var location: [String: [String]]
        
        enum CodingKeys: String, CodingKey {
            case location
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.location = try container.decode([String: [String]].self, forKey: .location)
        }
    }
        
}

//
//  MainRoomMeetingInfo.swift
//  App
//
//  Created by kokojong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct MainRoomMeetingInfo {
    let meetingID: Int
    let meetingName: String
    let minimumAlertMembers: Int
    let joinedUserCount, votingUserCount: Int
    let joinedUserInfoList: [UserInfoList]
    var userPromiseDateTimeList: [UserPromiseDateTimeList]
    var userPromisePlaceList: [UserPromisePlaceList]
    let meetingStatus: MeetingStatus
    var userVoteList: [Vote]
    var yaksokiType: YaksokiType
}

extension MainRoomMeetingInfo{
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
        let userInfoList: [UserInfoList]
        let votedUserCount: Int
    }
    
    // MARK: - UserVoteList
    
    struct Vote: Codable {
        let location: String
        let users: [String]
    }
    
    struct DynamicKey: CodingKey {
        let stringValue: String
        let intValue: Int?
        
        init(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        
        init(keyValue: String) {
            self.stringValue = keyValue
            self.intValue = nil
        }
    }
    
}

extension MainRoomMeetingInfo {
    static let emtpyData = MainRoomMeetingInfo(meetingID: -1, meetingName: "", minimumAlertMembers: 0, joinedUserCount: 0, votingUserCount: 0, joinedUserInfoList: [], userPromiseDateTimeList: [], userPromisePlaceList: [], meetingStatus: .waiting, userVoteList: [], yaksokiType: .eat)
}

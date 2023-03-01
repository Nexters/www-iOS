//
//  MeetingRoomResponseDTO.swift
//  App
//
//  Created by kokojong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct MeetingRoomResponseDTO: ModelType {
    let code: Int
    let message: String
    let result: Result?
}

extension MeetingRoomResponseDTO {
    struct Result: Codable {
        let meetingID: Int
        let meetingName: String
        let minimumAlertMembers: Int
        let hostName: String
        let currentUserName: String?
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
        let meetingStatus: MeetingStatus
        var userVoteList: [Vote]
        var yaksokiType: YaksokiType
        
        enum CodingKeys: String, CodingKey {
            case meetingID = "meetingId"
            case meetingName, minimumAlertMembers, hostName, currentUserName, isHost, joinedUserCount, votingUserCount, meetingCode, shortLink, confirmedDate, confirmedTime, confirmedPlace, isJoined, startDate, endDate, joinedUserInfoList, userPromiseDateTimeList, userPromisePlaceList, meetingStatus, userVoteList, yaksokiType
        }
        
    }
}

extension MeetingRoomResponseDTO {
    struct VoteList: Codable {
        let location: String
        let users: [String]
        
        enum CodingKeys: String, CodingKey {
            case location
            case users = "userVoteList"
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
    
    struct Vote: Codable {
          let location: String
          let users: [String]

          init(from decoder: Decoder) throws {
              let container = try decoder.container(keyedBy: DynamicKey.self)
              guard let key = container.allKeys.first?.stringValue else {
                  throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "No keys in JSON object"))
              }
              location = key
              users = try container.decode([String].self, forKey: DynamicKey(keyValue: key))
          }

          func encode(to encoder: Encoder) throws {
              var container = encoder.container(keyedBy: DynamicKey.self)
              try container.encode(users, forKey: DynamicKey(keyValue: location))
          }
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

extension MeetingRoomResponseDTO {
    
    func toDomian() -> MainRoomMeetingInfo {
        guard let result = result else { return MainRoomMeetingInfo.emtpyData }
        
        var joinedUserInfoList: [MainRoomMeetingInfo.UserInfoList] = []
        for joinedUserInfo in result.joinedUserInfoList {
            joinedUserInfoList.append(MainRoomMeetingInfo.UserInfoList(joinedUserName: joinedUserInfo.joinedUserName, characterType: joinedUserInfo.characterType))
        }
        
        var userPromiseDateTimeList: [MainRoomMeetingInfo.UserPromiseDateTimeList] = []
        for userPromiseDateTime in result.userPromiseDateTimeList {
            
            var userInfoList: [MainRoomMeetingInfo.UserInfoList] = []
            
            userPromiseDateTime.userInfoList.forEach {
                userInfoList.append(MainRoomMeetingInfo.UserInfoList(joinedUserName: $0.joinedUserName, characterType: $0.characterType))
            }
            
            userPromiseDateTimeList.append(MainRoomMeetingInfo.UserPromiseDateTimeList(promiseDate: userPromiseDateTime.promiseDate, promiseTime: userPromiseDateTime.promiseTime, promiseDayOfWeek: userPromiseDateTime.promiseDayOfWeek, userInfoList: userInfoList))
        }
        
        var userPromisePlaceList: [MainRoomMeetingInfo.UserPromisePlaceList] = []
        for userPromisePlace in result.userPromisePlaceList {
            userPromisePlaceList.append(MainRoomMeetingInfo.UserPromisePlaceList(userName: userPromisePlace.userName, userCharacter: userPromisePlace.userCharacter, promisePlace: userPromisePlace.promisePlace))
        }
        
        var userVoteList: [MainRoomMeetingInfo.Vote] = []
        for userVote in result.userVoteList {
            userVoteList.append(MainRoomMeetingInfo.Vote(location: userVote.location, users: userVote.users))
        }
        
        let mainRoomMeetingInfo = MainRoomMeetingInfo(
            meetingID: result.meetingID,
            meetingName: result.meetingName,
            minimumAlertMembers: result.minimumAlertMembers,
            joinedUserCount: result.joinedUserCount,
            votingUserCount: result.votingUserCount,
            joinedUserInfoList: joinedUserInfoList,
            userPromiseDateTimeList: userPromiseDateTimeList,
            userPromisePlaceList: userPromisePlaceList,
            meetingStatus: result.meetingStatus,
            userVoteList: userVoteList, yaksokiType: result.yaksokiType)
        
        return mainRoomMeetingInfo
    }
    
}

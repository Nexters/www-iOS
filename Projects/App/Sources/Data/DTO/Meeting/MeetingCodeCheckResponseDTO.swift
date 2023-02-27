//
//  MeetingCodeCheckRequest.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/27.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct MeetingCodeCheckResponseDTO: Codable {
    let code: Int
    let message: String
    var result: Result?
}


extension MeetingCodeCheckResponseDTO {
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
        let meetingStatus: MeetingStatus
        var userVoteList: [Vote]
        
        enum CodingKeys: String, CodingKey {
            case meetingID = "meetingId"
            case meetingName, minimumAlertMembers, hostName, currentUserName, isHost, joinedUserCount, votingUserCount, meetingCode, shortLink, confirmedDate, confirmedTime, confirmedPlace, isJoined, startDate, endDate, joinedUserInfoList, userPromiseDateTimeList, userPromisePlaceList, meetingStatus, userVoteList
        }
        
    }
    
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

extension MeetingCodeCheckResponseDTO {

    func toDomain() -> MeetingInfoToJoin {
        guard let result = result else { return MeetingInfoToJoin(id: -1, meetingCode: "", meetingName: "", startDate: "", endDate:"", placelist: []) }
        
        var places: [WrappedPlace] = []
        for promisePlace in result.userPromisePlaceList {
            let place = WrappedPlace(isFromLocal: false,
                                     place: Place(title: promisePlace.promisePlace))
            places.append(place)
        }
        
        return MeetingInfoToJoin(id: result.meetingID,
                                 meetingCode: result.meetingCode,
                                 meetingName: result.meetingName,
                                 startDate: result.startDate,
                                 endDate:result.endDate,
                                 placelist: places)
    }
    
}

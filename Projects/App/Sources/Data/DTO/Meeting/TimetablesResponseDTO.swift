//
//  TimetablesResponseDTO.swift
//  App
//
//  Created by kokojong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct TimetablesResponseDTO: ModelType {
    let code: Int
    let message: String
    let result: [Result]?
}

extension TimetablesResponseDTO {
    struct Result: Codable {
        let timetableID: Int
        let promiseDate: String
        let promiseTime: PromiseTime
        let promiseDayOfWeek: String
        let userInfoList: [UserInfoList]

        enum CodingKeys: String, CodingKey {
            case timetableID = "timetableId"
            case promiseDate, promiseTime, promiseDayOfWeek, userInfoList
        }
    }
    
    struct UserInfoList: Codable {
        let joinedUserName: String
        let characterType: String
    }
}

extension TimetablesResponseDTO {
    func toDomain() -> [TimetablesInfo] {
        guard let result = result else { return [] }
        
        var TimetablesInfos: [TimetablesInfo] = []
        
        for result in result {
            var userInfoList: [TimetablesInfo.UserInfoList] = []
            for list in result.userInfoList {
                userInfoList.append(TimetablesInfo.UserInfoList(joinedUserName: list.joinedUserName, characterType: list.characterType))
            }
            TimetablesInfos.append(TimetablesInfo(timetableID: result.timetableID, promiseDate: result.promiseDate, promiseTime: result.promiseTime, promiseDayOfWeek: result.promiseDayOfWeek, userInfoList: userInfoList))
        }
        
        return TimetablesInfos
        
    }
}

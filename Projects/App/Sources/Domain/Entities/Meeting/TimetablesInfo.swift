//
//  TimetablesInfo.swift
//  App
//
//  Created by kokojong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct TimetablesInfo {
    let timetableID: Int
    let promiseDate: String
    let promiseTime: PromiseTime
    let promiseDayOfWeek: String
    let userInfoList: [UserInfoList]
}

extension TimetablesInfo {
    static let emptyData = TimetablesInfo(
        timetableID: -1,
        promiseDate: "2023-01-01",
        promiseTime: .morning,
        promiseDayOfWeek: "월",
        userInfoList: [])
    
    struct UserInfoList: Codable {
        let joinedUserName: String
        let characterType: String
    }
}

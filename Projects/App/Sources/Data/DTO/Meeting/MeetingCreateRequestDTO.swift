//
//  MeetingCreateRequestDTO.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct MeetingCreateRequestDTO: Codable {
    let userName, meetingName: String
    let startDate, endDate: String
    let minimumAlertMembers: Int
    let promiseDateTimeList: [PromiseDateTimeList]
    let promisePlaceList: [String]
}

struct PromiseDateTimeList: Codable {
    let promiseDate, promiseTime: String
}

//
//  MeetingJoinRequestDTO.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/27.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct MeetingJoinRequestDTO: Codable {
    let nickname: String
    let promisePlaceList: [String]
    let userPromiseTimeList: [SelectedTime]
}

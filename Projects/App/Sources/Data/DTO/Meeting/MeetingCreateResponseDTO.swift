//
//  MeetingCreateResponseDTO.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct MeetingCreateResponseDTO: Codable {
    let code: Int
    let message: String
    let result: Result
}

struct Result: Codable {
    let meetingCode: String
    let shortLink: String
}

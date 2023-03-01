//
//  PlaceVoteRequestDTO.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/02.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct PlaceVoteRequestDTO: Codable {
    let meetingPlaceIDList: [Int]

    enum CodingKeys: String, CodingKey {
        case meetingPlaceIDList = "meetingPlaceIdList"
    }
}

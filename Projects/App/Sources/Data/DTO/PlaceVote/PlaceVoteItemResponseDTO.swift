//
//  PlaceVoteItemResponseDTO.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/02.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct PlaceVoteItemResponseDTO: Codable {
    let code: Int
    let message: String
    let result: Result
}

extension PlaceVoteItemResponseDTO {
    
    // MARK: - Result
    struct Result: Codable {
        let userPromisePlaceList: [UserPromisePlaceList]
    }

    // MARK: - UserPromisePlaceList
    struct UserPromisePlaceList: Codable {
        let placeID: Int
        let userName, userCharacter, promisePlace: String
        let userInfoList: [UserInfoList]
        let votedUserCount: Int

        enum CodingKeys: String, CodingKey {
            case placeID = "placeId"
            case userName, userCharacter, promisePlace, userInfoList, votedUserCount
        }
    }

    // MARK: - UserInfoList
    struct UserInfoList: Codable {
        let joinedUserName, characterType: String
    }

}

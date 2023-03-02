//
//  PlaceVote.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct PlaceVote: Hashable {
    let id: Int
    let placeName: String
    let count: Int
    var isMyVote: Bool
}

extension PlaceVote {
    
    static let mockData: [PlaceVote] = [
        PlaceVote(id: 1,
                  placeName: "합정역",
                  count: 5,
                  isMyVote: false),
        PlaceVote(id: 2,
                  placeName: "사당역",
                  count: 2,
                  isMyVote: false),
        PlaceVote(id: 3,
                  placeName: "이수역",
                  count: 9,
                  isMyVote: false),
        PlaceVote(id: 4,
                  placeName: "보라매역",
                  count: 3,
                  isMyVote: false),
        PlaceVote(id: 5,
                  placeName: "강남역",
                  count: 0,
                  isMyVote: false)
    ]
    
}


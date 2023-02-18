//
//  Place.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/16.
//  Copyright © 2023 com.promise8. All rights reserved.
//

struct Place: Hashable {
    let title: String
}

extension Place {
    
    static let mockServerData: [Place] = [
        Place(title: "선릉역"),
        Place(title: "역삼역"),
        Place(title: "강남역")
    ]
    
    static let mockLocalData: [Place] = [
        Place(title: "부산"),
        Place(title: "해운대"),
        Place(title: "광안리")
    ]

}

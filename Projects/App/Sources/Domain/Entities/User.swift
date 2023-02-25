//
//  User.swift
//  App
//
//  Created by kokojong on 2023/02/25.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct User: Hashable {
    let id: String
    let name: String
    let isHost: Bool
}

extension User {
    static let mockData: [User] = [
        User(id: "1", name: "윤여종", isHost: true),
        User(id: "2", name: "임주영", isHost: false),
        User(id: "3", name: "강성찬", isHost: false),
        User(id: "4", name: "강용수", isHost: false),
        User(id: "5", name: "윤서연", isHost: false),
        User(id: "6", name: "신민서", isHost: false),
        User(id: "7", name: "장석준", isHost: false),
        User(id: "8", name: "정찬희", isHost: false),
        User(id: "11", name: "윤여종", isHost: true),
        User(id: "12", name: "임주영", isHost: false),
        User(id: "13", name: "강성찬", isHost: false),
        User(id: "14", name: "강용수", isHost: false),
        User(id: "15", name: "윤서연", isHost: false),
        User(id: "16", name: "신민서", isHost: false),
        User(id: "17", name: "장석준", isHost: false),
        User(id: "18", name: "정찬희", isHost: false),
    ]
}

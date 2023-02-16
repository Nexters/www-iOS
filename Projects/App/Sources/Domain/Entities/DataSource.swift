//
//  DataSource.swift
//  UI
//
//  Created by 김승창 on 2023/02/10.
//  Copyright © 2023 Charlie. All rights reserved.
//

final class LocalStorage {
    private let mockData: [Place] = [
        Place(title: "로컬 장소 1"),
        Place(title: "로컬 길이 긴거"),
        Place(title: "로컬 짧")
    ]
    
    
    func getData() -> [Place] {
        return mockData
    }
}

final class Server {
    private let mockData: [Place] = [
        Place(title: "서버 장소 1"),
        Place(title: "서버 길이 긴거"),
        Place(title: "서버 짧")
    ]
    
    func getDataa() -> [Place] {
        return mockData
    }
}

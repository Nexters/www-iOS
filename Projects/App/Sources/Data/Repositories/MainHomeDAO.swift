//
//  MainHomeDAO.swift
//  App
//
//  Created by kokojong on 2023/02/14.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxSwift

final class MainHomeDAO: MeetingRepository {
    
    private let network: RxMoyaProvider<MeetingAPI>
    
    init(network: RxMoyaProvider<MeetingAPI>) {
        self.network = network
    }
    
    func fetchMainHomeMeeting() -> Single<MainHomeMeeting> {
        
        return network.request(.getMeetings)
            .map(MeetingMainGetResponseDTO.self)
            .do { print("MeetingMainGetResponseDTO", $0) }
            .map{ $0.result }
            .map{ $0.toDomain() }
            .asSingle()
    }
    
    
}

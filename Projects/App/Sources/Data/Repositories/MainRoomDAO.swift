//
//  MainRoomDAO.swift
//  App
//
//  Created by kokojong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxSwift

final class MainRoomDAO: MeetingRoomRepository {
    
    private let network: RxMoyaProvider<MeetingAPI>
    
    init(network: RxMoyaProvider<MeetingAPI>) {
        self.network = network
    }
    
    func fetchMainRoomMeeting(id: Int) -> Single<MainRoomMeetingInfo> {
        
        let result =  network.request(.fetchMeetingRoom(meetingId: id))
            .map(MeetingRoomResponseDTO.self)
            .map { $0.toDomian() }
            .asSingle()
        
        return result
    }
    
    func fetchTimetables(id: Int) -> Single<[TimetablesInfo]> {
        let result = network.request(.fetchTimetables(meetingId: id))
            .map(TimetablesResponseDTO.self)
            .map { $0.toDomain()}
            .asSingle()
        
        return result
    }
//
//    func fetchVotes(id: Int) -> Single<> {
//
//    }
    
}

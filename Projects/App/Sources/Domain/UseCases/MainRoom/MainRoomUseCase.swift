//
//  MainRoomUseCase.swift
//  App
//
//  Created by kokojong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift

protocol MainRoomUseCaseProtocol {
    var roomId: Int { get }
}

final class MainRoomUseCase: MainRoomUseCaseProtocol {
    
    private let meetingRoomRepository: MeetingRoomRepository
    
    init(meetingRoomRepository: MeetingRoomRepository) {
        self.meetingRoomRepository = meetingRoomRepository
    }
    
    var roomId: Int = 1
    
    func fetchMainRoomMeeting(id: Int) -> Single<MainRoomMeetingInfo> {
        return meetingRoomRepository.fetchMainRoomMeeting(id: id)
    }
    
    func fetchTimetables(id: Int) -> Single<[TimetablesInfo]> {
        return meetingRoomRepository.fetchTimetables(id: id)
    }
}

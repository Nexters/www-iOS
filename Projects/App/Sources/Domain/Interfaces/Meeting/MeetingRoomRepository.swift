//
//  MeetingRoomRepository.swift
//  App
//
//  Created by kokojong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxSwift

protocol MeetingRoomRepository {
    func fetchMainRoomMeeting(id: Int) -> Single<MainRoomMeetingInfo>
    
    func fetchTimetables(id: Int) -> Single<[TimetablesInfo]>
}

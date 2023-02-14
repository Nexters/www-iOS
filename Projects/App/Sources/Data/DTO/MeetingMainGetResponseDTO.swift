//
//  MeetingMainGetResponseDTO.swift
//  App
//
//  Created by kokojong on 2023/02/13.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct MeetingMainGetResponseDTO: ModelType {
    let code: Int
    let message: String
    let result: MeetingMainGetResDTOWrapper
}

extension MeetingMainGetResponseDTO {
    struct MeetingMainGetResDTOWrapper: ModelType {
        let meetingMainIngGetResDtoList: [MeetingMainGetResDto]
        let meetingMainEndGetResDtoList: [MeetingMainGetResDto]
    }
}

extension MeetingMainGetResponseDTO.MeetingMainGetResDTOWrapper {
    struct MeetingMainGetResDto: ModelType {
        let conditionCount: Int
        let hostName: String
        let joinedUserCount: Int
        let meetingId: Int
        let meetingName: String
        let meetingStatus: MeetingStatus
        let promiseDate: String? // Date
        let promisePlace: String?
        let promiseTime: PromiseTime?
        let votingUserCount: Int
    }
}

extension MeetingMainGetResponseDTO.MeetingMainGetResDTOWrapper {
    func toDomain() -> MainHomeMeeting {
        let proceedingMeetings =  self.meetingMainIngGetResDtoList.map { $0.toDomain() }
        let endedMeetings = self.meetingMainEndGetResDtoList.map { $0.toDomain() }
        
        return .init(proceedingMeetings: proceedingMeetings, endedMeetings: endedMeetings)
    }
}


extension MeetingMainGetResponseDTO.MeetingMainGetResDTOWrapper.MeetingMainGetResDto {
    func toDomain() -> Meeting {
        return Meeting(conditionCount: conditionCount, hostName: hostName, joinedUserCount: joinedUserCount, meetingId: meetingId, meetingName: meetingName, meetingStatus: meetingStatus, promiseDate: promiseDate, promisePlace: promisePlace, promiseTime: promiseTime, votingUserCount: votingUserCount)
    }
}

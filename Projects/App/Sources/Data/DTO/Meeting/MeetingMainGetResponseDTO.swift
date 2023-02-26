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
        let meetingIngList: [MeetingMainGetResDto]
        let meetingEndList: [MeetingMainGetResDto]
    }
}

extension MeetingMainGetResponseDTO.MeetingMainGetResDTOWrapper {
    struct MeetingMainGetResDto: ModelType {
        let confirmedDate: String?
        let confirmedPlace: String?
        let confirmedTime: PromiseTime?
        let hostName: String
        let joinedUserCount: Int
        let meetingId: Int
        let meetingName: String
        let meetingStatus: MeetingStatus
        let minimumAlertMembers: Int
        let votingUserCount: Int
    }
}

extension MeetingMainGetResponseDTO.MeetingMainGetResDTOWrapper {
    func toDomain() -> MainHomeMeeting {
        let proceedingMeetings =  self.meetingIngList.map { $0.toDomain() }
        let endedMeetings = self.meetingEndList.map { $0.toDomain() }
        
        return .init(proceedingMeetings: proceedingMeetings, endedMeetings: endedMeetings)
    }
}


extension MeetingMainGetResponseDTO.MeetingMainGetResDTOWrapper.MeetingMainGetResDto {
    func toDomain() -> MeetingMain {
        return MeetingMain(confirmedDate: confirmedDate, confirmedPlace: confirmedPlace, confirmedTime: confirmedTime, hostName: hostName, joinedUserCount: joinedUserCount, meetingId: meetingId, meetingName: meetingName, meetingStatus: meetingStatus, minimumAlertMembers: minimumAlertMembers, votingUserCount: votingUserCount)
    }
}

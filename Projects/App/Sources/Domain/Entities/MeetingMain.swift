//
//  Meeting.swift
//  App
//
//  Created by kokojong on 2023/02/13.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct MeetingMain: Hashable {
    let id = UUID()
    
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
    let yaksoki: YacksokoiType
}

struct MainHomeMeeting {
    let proceedingMeetings: [MeetingMain]
    let endedMeetings: [MeetingMain]
}

extension MainHomeMeeting {
    static let mockData: MainHomeMeeting = {
        let proceedingMeetings: [MeetingMain] =
        [
            MeetingMain(confirmedDate: "2023-01-01", confirmedPlace: "갱냄1", confirmedTime: .morning, hostName: "여종", joinedUserCount: 5, meetingId: 0, meetingName: "갱냄 패티1", meetingStatus: .voting, minimumAlertMembers: 3, votingUserCount: 1, yaksoki: .eat),
            MeetingMain(confirmedDate: nil, confirmedPlace: "갱냄2", confirmedTime: .lunch, hostName: "여종", joinedUserCount: 5, meetingId: 0, meetingName: "갱냄 패티2", meetingStatus: .voted, minimumAlertMembers: 3, votingUserCount: 2, yaksoki: .play),
            MeetingMain(confirmedDate: "2023-01-01", confirmedPlace: nil, confirmedTime: .dinner, hostName: "여종", joinedUserCount: 5, meetingId: 0, meetingName: "갱냄 패티3", meetingStatus: .waiting, minimumAlertMembers: 3, votingUserCount: 3, yaksoki: .rest),
            MeetingMain(confirmedDate: "2023-01-01", confirmedPlace: nil, confirmedTime: .dinner, hostName: "여종", joinedUserCount: 5, meetingId: 0, meetingName: "갱냄 패티4", meetingStatus: .confirmed, minimumAlertMembers: 3, votingUserCount: 3, yaksoki: .work),
            MeetingMain(confirmedDate: "2023-03-01", confirmedPlace: nil, confirmedTime: .dinner, hostName: "여종", joinedUserCount: 5, meetingId: 0, meetingName: "갱냄 패티4", meetingStatus: .confirmed, minimumAlertMembers: 3, votingUserCount: 3, yaksoki: .work)
        ]
        
        var endedMeetings: [MeetingMain] =
        [
            MeetingMain(confirmedDate: "2023-01-01", confirmedPlace: "홍대1", confirmedTime: .morning, hostName: "찬희", joinedUserCount: 5, meetingId: 0, meetingName: "홍대 패티1", meetingStatus: .voting, minimumAlertMembers: 2, votingUserCount: 1, yaksoki: .work),
            MeetingMain(confirmedDate: "2023-01-01", confirmedPlace: "홍대2", confirmedTime: .morning, hostName: "찬희", joinedUserCount: 5, meetingId: 0, meetingName: "홍대 패티2", meetingStatus: .voting, minimumAlertMembers: 2, votingUserCount: 2, yaksoki: .work),
            MeetingMain(confirmedDate:  nil, confirmedPlace: nil, confirmedTime: nil, hostName: "찬희", joinedUserCount: 5, meetingId: 0, meetingName: "홍대 패티3", meetingStatus: .voting, minimumAlertMembers: 2, votingUserCount: 3, yaksoki: .eat),
            MeetingMain(confirmedDate:  nil, confirmedPlace: nil, confirmedTime: nil, hostName: "찬희", joinedUserCount: 5, meetingId: 0, meetingName: "홍대 패티4", meetingStatus: .voting, minimumAlertMembers: 2, votingUserCount: 3, yaksoki: .rest)
        ]
        
        return MainHomeMeeting(proceedingMeetings: proceedingMeetings, endedMeetings: endedMeetings)
    }()
    
    
}

//
//  Meeting.swift
//  App
//
//  Created by kokojong on 2023/02/13.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct Meeting {
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

struct MainHomeMeeting {
    let proceedingMeetings: [Meeting]
    let endedMeetings: [Meeting]
}

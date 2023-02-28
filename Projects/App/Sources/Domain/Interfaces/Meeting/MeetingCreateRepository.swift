//
//  MeetingCreateRepository.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

protocol MeetingCreateRepository {
    
    func postMeeting(userName: String, meetingName: String, startDate: String, endDate: String, minMember: Int, selectedTime: [SelectedTime], placeList: [WrappedPlace])

}

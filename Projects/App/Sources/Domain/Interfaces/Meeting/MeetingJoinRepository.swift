//
//  MeetingJoinRepository.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/27.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift

protocol MeetingJoinRepository {
//    func fetchMeetingStatusWithCode(with code: String) -> Observable<MeetingInfoToJoin>
    
    func fetchMeetingStatusWithCode(with code: String) -> Observable<Result<MeetingInfoToJoin, JoinMeetingError>>
    
    func postMeeting(meetingId: Int, username: String, times: [SelectedTime], places: ([WrappedPlace])) -> Observable<Result<MeetingJoinResponseDTO, JoinMeetingError>>

}

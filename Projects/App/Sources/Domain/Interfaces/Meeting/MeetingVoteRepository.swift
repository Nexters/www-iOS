//
//  MeetingVoteRepository.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/02.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift

protocol MeetingVoteRepository {
    func fetchVoteUsers(meetingId id: Int) -> Observable<Int>
    func fetchPlaceToVoteList(meetingId id: Int) -> Observable<[PlaceVote]>
}

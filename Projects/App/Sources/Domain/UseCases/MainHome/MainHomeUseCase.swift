//
//  MainHomeUseCase.swift
//  App
//
//  Created by kokojong on 2023/02/13.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift

protocol MainHomeUseCaseProtocol {
    var proceedingMeetings: BehaviorSubject<[String]> { get }
    var endedMeetings: BehaviorSubject<[String]> { get }
}

final class MainHomeUseCase: MainHomeUseCaseProtocol {
    
    private let meetingRepository: MeetingRepository
    
    init(meetingRepository: MeetingRepository) {
        self.meetingRepository = meetingRepository
    }
    
    var proceedingMeetings = BehaviorSubject<[String]>(value: [])
    
    var endedMeetings = BehaviorSubject<[String]>(value: [])
    
    func fetchMainHomeMeeting() -> Single<MainHomeMeeting> {
        return meetingRepository.fetchMainHomeMeeting()
//        return Observable.just(MainHomeMeeting.mockData).asSingle()
    }
}

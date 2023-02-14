//
//  MeetingRepository.swift
//  App
//
//  Created by kokojong on 2023/02/13.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxSwift

protocol MeetingRepository {
    func fetchMainHomeMeeting() -> Single<MainHomeMeeting>
}

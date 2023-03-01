//
//  RoomHomeViewModel.swift
//  App
//
//  Created by kokojong on 2023/02/28.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class RoomHomeViewModel: BaseViewModel {
    
    private let mainRoomUseCase: MainRoomUseCase
    
    init(mainRoomUseCase: MainRoomUseCase) {
        self.mainRoomUseCase = mainRoomUseCase
    }
  
    struct Input {
        let viewDidLoad: Observable<Void>
    }

    struct Output {
        let mainRoomMeetingInfo: Single<MainRoomMeetingInfo>
//        let timetablesInfo: Single<[TimetablesInfo]>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let mainRoomMeetingInfo = input.viewDidLoad.asSingle()
            .flatMap { _ -> Single<MainRoomMeetingInfo> in
                return self.mainRoomUseCase.fetchMainRoomMeeting(id: self.mainRoomUseCase.roomId) // test
            }
        
//        let timetablesInfo = input.viewDidLoad.asSingle()
//            .flatMap { _ -> Single<[TimetablesInfo]> in
//                return self.mainRoomUseCase.fetchTimetables(id: self.mainRoomUseCase.roomId)
//            }
        
        return Output(mainRoomMeetingInfo: mainRoomMeetingInfo)
    }
}

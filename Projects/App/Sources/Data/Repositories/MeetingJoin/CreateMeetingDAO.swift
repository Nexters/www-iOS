//
//  CreateMeetingDAO.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift

final class CreateMeetingDAO: MeetingCreateRepository {
    
    private let network: RxMoyaProvider<MeetingAPI>
    private let disposeBag = DisposeBag()
    
    init(network: RxMoyaProvider<MeetingAPI>) {
        self.network = network
    }
    
    func postMeeting(
        userName: String, meetingName: String, startDate: String, endDate: String, minMember: Int, selectedTime: [SelectedTime], placeList: [WrappedPlace]
    ) {

        var timelist: [PromiseDateTimeList] = []
        for time in selectedTime {
            let item = PromiseDateTimeList(promiseDate: time.promiseDate,
                                promiseTime: time.promiseTime.rawValue)
            timelist.append(item)
        }
        
        var placelist: [String] = []
        for place in placeList {
            placelist += [place.place.title]
        }
        
        let reqDTO = MeetingCreateRequestDTO(
            userName: userName,
            meetingName: meetingName,
            startDate: startDate,
            endDate: endDate,
            minimumAlertMembers: minMember,
            promiseDateTimeList: timelist,
            promisePlaceList: placelist
        )
        
        self.network.request(.createMeeting(body: reqDTO))
            .bind { response in
                print("🚧🚧🚧🚧",response)
            }
            .disposed(by: disposeBag)
        
    }
    
}


extension MeetingJoinRepository {
     func mapCreateMeetingError(from errorCode: Int) -> JoinMeetingError {
        switch errorCode {
        case 403:
            return .accessDenied
        case 500:
            return .serverError
        case 1000:
            return .serverError
        default:
            return .unknown
        }
    }
}

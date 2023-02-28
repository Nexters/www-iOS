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
    
    func postMeeting() {
        
        let reqDTO = MeetingCreateRequestDTO(
            userName: "정찬희",
            meetingName: "약속이름은이걸로!",
            startDate: "2023-03-05",
            endDate: "2023-03-15",
            minimumAlertMembers: 3,
            promiseDateTimeList: [
                PromiseDateTimeList(promiseDate: "2023-03-06",
                                    promiseTime: "DINNER"),
                PromiseDateTimeList(promiseDate: "2023-03-06",
                                    promiseTime: "LUNCH"),
            ],
            promisePlaceList: ["신논현역", "신분당선어딘가"]
        )
        
        self.network.request(.createMeeting(body: reqDTO))
            .bind { response in
                print("🚧🚧🚧🚧",response)
            }
            .disposed(by: disposeBag)
        
        
//        {
//          "code": 0,
//          "message": "Success",
//          "result": {
//            "meetingCode": "GhaGOT",
//            "shortLink": "https://whenwheres.page.link/YYd5uL8P7nD2zoVH9"
//          }
//        }
//
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

//
//  JoinMeetingDAO.swift
//  Guest 가 Meeting Room 에 Join 할때 사용합니다.
//  App
//
//  Created by Chanhee Jeong on 2023/02/27.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift

final class JoinMeetingDAO: MeetingJoinRepository {
    
    private let network: RxMoyaProvider<MeetingAPI>
    
    private let disposeBag = DisposeBag()
    
    init(network: RxMoyaProvider<MeetingAPI>) {
        self.network = network
    }
    
    func fetchMeetingStatusWithCode(with meetingcode: String) -> RxSwift.Observable<MeetingCodeCheckResponseDTO> {
//        func fetchMeetingStatusWithCode() {
        // 테스트용 code : JOyMpM
//        let meetingCode = "JOyMpM"
        
//        network.request(.checkMeetingCode(code: meetingCode))
//            .subscribe(onNext: { response in
//                print("Request succeeded\(response)")
//            })
//            .disposed(by: disposeBag)
        
        return network.request(.checkMeetingCode(code: meetingcode
                                                ))
            .map(MeetingCodeCheckResponseDTO.self)
            .asObservable()
    }

    
}

enum JoinMeetingError: Error {
    case accessDenied
    case serverError
    case roomDoesntExist
    case userDoesntExist
    case roomAlreadyStarted
    case unknown
    
    public var localizedMsg: String {
        switch self {
        case .accessDenied:
            return "접근이 거부되었습니다."
        case .serverError:
            return "서버에서 에러가 발생하였습니다."
        case .roomDoesntExist:
            return "존재하지 않는 약속방 입니다."
        case .userDoesntExist:
            return "존재하지 않는 유저입니다. 앱을 재설치해주세요!"
        case .roomAlreadyStarted:
            return "이미 투표가 시작되어 참가할 수 없습니다."
        case .unknown:
            return "다시 참여를 시도해주세요."
        }
    }
}

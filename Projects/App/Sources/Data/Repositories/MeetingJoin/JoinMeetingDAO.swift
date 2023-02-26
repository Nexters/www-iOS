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
    
    
    func fetchMeetingStatusWithCode(with code: String) -> RxSwift.Observable<Result<MeetingInfoToJoin, JoinMeetingError>> {

        let result = Observable<Result<MeetingInfoToJoin, JoinMeetingError>>.create { [weak self] observer in
            
            self?.network.request(.checkMeetingCode(code: code))
                .map(MeetingCodeCheckResponseDTO.self)
                .subscribe(onNext: { [weak self] dto in
                    if dto.code == 0 {
                        observer.onNext(.success(dto.toDomain()))
                    } else {
                        let error = self?.mapJoinMeetingError(from: dto.code) ?? .unknown
                        observer.onNext(.failure(error))
                    }
                    observer.onCompleted()
                }, onError: { error in
                    observer.onNext(.failure(.unknown))
                    observer.onCompleted()
                })
                .disposed(by: self!.disposeBag)
            
            return Disposables.create()
        }
        
        return result
        
    }

    
}

extension JoinMeetingDAO {
    private func mapJoinMeetingError(from errorCode: Int) -> JoinMeetingError {
        switch errorCode {
        case 403:
            return .accessDenied
        case 500:
            return .serverError
        case 1000:
            return .serverError
        case 4000:
            return .roomDoesntExist
        case 4001:
            return .userDoesntExist
        case 5000:
            return .roomAlreadyStarted
        default:
            return .unknown
        }
    }
}

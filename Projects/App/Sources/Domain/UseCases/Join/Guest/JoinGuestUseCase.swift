//
//  JoinGuestUseCase.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift


protocol JoinGuestUseCaseProtocol {
    var roomCode: BehaviorSubject<String> { get }
    var roomName: String { get }
    var userName: BehaviorSubject<String> { get }
    var placeList: PublishSubject<[WrappedPlace]> { get }
    var myPlaceList: PublishSubject<[WrappedPlace]> { get }
    var selectedTimes: [SelectedTime] { get set }
}

final class JoinGuestUseCase: JoinGuestUseCaseProtocol {
    
    private let meetingJoinRepository: MeetingJoinRepository
    
    // MARK: - Properties
    var roomCode = BehaviorSubject<String>(value: "")
    var roomName: String = "방이름"
    var userName = BehaviorSubject<String>(value: "")
    var placeList = PublishSubject<[WrappedPlace]>()
    var myPlaceList = PublishSubject<[WrappedPlace]>()
    var myTimeList = PublishSubject<[SelectedTime]>()
    let startDate = "2023-03-06".strToDate()
    let endDate = "2023-03-15".strToDate()
    internal var selectedTimes: [SelectedTime] = []
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    init(meetingJoinRepository: MeetingJoinRepository) {
        self.meetingJoinRepository = meetingJoinRepository
    }
    
    func getServerPlaceList() -> [WrappedPlace] {
        return Place.mockServerData
            .map { WrappedPlace(isFromLocal: false, place: $0) }
    }
    
    func addMyPlaces(_ places: [WrappedPlace]) {
        self.placeList.onNext(places)
    }
    
    func addSelectedTimes(_ times: [SelectedTime]) {
        self.selectedTimes = times
    }

    func checkMeetingRoomAvailable() -> Observable<Result<Bool, JoinMeetingError>> {

        let result = Observable<Result<Bool, JoinMeetingError>>.create { [weak self] observer in
            guard let roomCode = try! self?.roomCode.value() else {
                observer.onNext(.failure(.unknown))
                observer.onCompleted()
                return Disposables.create()
            }

            self?.meetingJoinRepository.fetchMeetingStatusWithCode(with: roomCode)
                .subscribe(onNext: { [weak self] response in
                    if response.code == 0 {
                        observer.onNext(.success(true))
                    } else {
                        let error = self?.mapJoinMeetingError(from: response.code) ?? .unknown
                        observer.onNext(.failure(error))
                    }
                    observer.onCompleted()
                })
                .disposed(by: self!.disposeBag)
            
            return Disposables.create()
        }
        
        return result
    }


}

// MARK: - Privates
private extension JoinGuestUseCase {
    
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


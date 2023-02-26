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
    var id: Int { get }
    var roomName: String { get }
    var placeList: [WrappedPlace]{ get }
    var startDate: Date? { get }
    var endDate: Date? { get }
    var userName: BehaviorSubject<String> { get }
    var roomCode: BehaviorSubject<String> { get }
    var selectedTimes: [SelectedTime] { get set }
}

final class JoinGuestUseCase: JoinGuestUseCaseProtocol {
    
    private let meetingJoinRepository: MeetingJoinRepository
    
    // MARK: - Properties
    internal var id: Int = -1
    internal var roomName: String = ""
    internal var startDate: Date? = nil
    internal var endDate: Date? = nil
    internal var placeList: [WrappedPlace] = []
    var roomCode = BehaviorSubject<String>(value: "")
    var userName = BehaviorSubject<String>(value: "")
    internal var myPlaceList: [WrappedPlace] = []
    internal var selectedTimes: [SelectedTime] = []
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    init(meetingJoinRepository: MeetingJoinRepository) {
        self.meetingJoinRepository = meetingJoinRepository
    }
    
    func getServerPlaceList() -> [WrappedPlace] {
        return placeList
    }
    
    func addMyPlaces(_ places: [WrappedPlace]) {
        self.myPlaceList += places
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
                .subscribe(onNext: { [weak self] result in
                    switch result {
                    case .success:
                        observer.onNext(.success(true))
                        let entity = try! result.get()
                        self?.id = entity.id
                        self?.roomName = entity.meetingName
                        self?.placeList += entity.placelist
                        self?.startDate = entity.startDate.strToDate()
                        self?.endDate = entity.endDate.strToDate()
                    case .failure(let error):
                        observer.onNext(.failure(error))
                    }
                })
                .disposed(by: self!.disposeBag)
            
            return Disposables.create()
        }
        
        return result
    }
    

}


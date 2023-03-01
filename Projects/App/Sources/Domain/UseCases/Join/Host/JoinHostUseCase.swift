//
//  JoinAdminUseCase.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/09.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift

protocol JoinHostUseCaseProtocol {
    var roomName: BehaviorSubject<String> { get }
    var userName: BehaviorSubject<String> { get }
    var minUser: BehaviorSubject<Int> { get }
    var placeList: AsyncSubject<[WrappedPlace]> { get }
    var selectedTimes: [SelectedTime] { get set }
    var myPlaceList: [WrappedPlace] { get set }
}

final class JoinHostUseCase: JoinHostUseCaseProtocol {
    
    private let meetingCreateRepository: MeetingCreateRepository
    
    // MARK: - Properties
    var roomName = BehaviorSubject<String>(value: "")
    var userName = BehaviorSubject<String>(value: "")
    var minUser = BehaviorSubject<Int>(value: 1)
    var placeList = AsyncSubject<[WrappedPlace]>()
    var startDate = BehaviorSubject<Date>(value: Date())
    var endDate = BehaviorSubject<Date>(value: Date())
    var roomcode = ""
    internal var selectedTimes: [SelectedTime] = []
    internal var myPlaceList: [WrappedPlace] = []
    
    private let disposeBag = DisposeBag()

    
    // MARK: - Methods
    init(meetingCreateRepository: MeetingCreateRepository) {
        self.meetingCreateRepository = meetingCreateRepository
    }
    
    func updateMinUser(with value: Int) {
        let current = try! self.minUser.value()
        if current > 1 && current < 20 {
            self.minUser.onNext(current + value)
        }
    }
    
    func addMyPlaces(_ places: [WrappedPlace]) {
        self.myPlaceList += places
    }
    
    func addSelectedTimes(_ times: [SelectedTime]) {
        self.selectedTimes = times
    }
    
    func updateStartDate(date: Date) {
        let current = try! self.startDate.value()
        self.startDate.onNext(date)
    }
    
    func updateEndDate(date: Date) {
        let current = try! self.endDate.value()
        self.endDate.onNext(date)
    }
    
    
    func postMeeting() -> Observable<String> {
        let start = try! self.startDate.value()
        let end = try! self.endDate.value()

        return self.meetingCreateRepository.postMeeting(userName: try! self.userName.value(),
                                                 meetingName: try! self.roomName.value(),
                                                 startDate: start.formatted("yyyy-MM-dd"),
                                                 endDate: end.formatted("yyyy-MM-dd"),
                                                 minMember: try! self.minUser.value(),
                                                 selectedTime: self.selectedTimes,
                                                 placeList: self.myPlaceList)
            .map { result in
                self.roomcode = result.meetingCode
                return result.meetingCode
            }
    }
    
}

// MARK: - Privates
private extension JoinHostUseCase {
    

}


extension String {
    func toDate() -> Date? { 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

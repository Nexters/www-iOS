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
    
    // MARK: - Methods
    init() {}
    
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


}

// MARK: - Privates
private extension JoinGuestUseCase {
    
}


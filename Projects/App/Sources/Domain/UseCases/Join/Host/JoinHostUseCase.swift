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
    var placeList: PublishSubject<[WrappedPlace]> { get }
    var selectedTimes: [SelectedTime] { get set }
}

final class JoinHostUseCase: JoinHostUseCaseProtocol {
    
    // MARK: - Properties
    var roomName = BehaviorSubject<String>(value: "")
    var userName = BehaviorSubject<String>(value: "")
    var minUser = BehaviorSubject<Int>(value: 1)
    var placeList = PublishSubject<[WrappedPlace]>()
    let startDate = "2023-03-06".strToDate()
    let endDate = "2023-03-15".strToDate()
    internal var selectedTimes: [SelectedTime] = []
    
    // MARK: - Methods
    init() {}
    
    func updateMinUser(with value: Int) {
        let current = try! self.minUser.value()
        if current > 1 && current < 20 {
            self.minUser.onNext(current + value)
        }
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

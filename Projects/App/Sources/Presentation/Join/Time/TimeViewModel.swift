//
//  TimeViewModel.swift
//  AppTests
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum TimePager {
    case back
    case place
    case error
}


var promiseDateMock = [
    PromiseDateViewData(date: Date(), dateLabel: "25(토)", status: [.notSelected, .notSelected, .notSelected, .notSelected]),
    PromiseDateViewData(date: Date(), dateLabel: "26(일)", status: [.notSelected, .notSelected, .notSelected, .notSelected]),
    PromiseDateViewData(date: Date(), dateLabel: "27(월)", status: [.notSelected, .notSelected, .notSelected, .notSelected]),
    PromiseDateViewData(date: Date(), dateLabel: "28(화)", status: [.notSelected, .notSelected, .notSelected, .notSelected]),
    PromiseDateViewData(date: Date(), dateLabel: "01(수)", status: [.notSelected, .notSelected, .notSelected, .notSelected]),
    PromiseDateViewData(date: nil, dateLabel: "-", status: [.disabled, .disabled, .disabled, .disabled]),
    PromiseDateViewData(date: nil, dateLabel: "-", status: [.disabled, .disabled, .disabled, .disabled]),
    PromiseDateViewData(date: nil, dateLabel: "-", status: [.disabled, .disabled, .disabled, .disabled]),
    PromiseDateViewData(date: nil, dateLabel: "-", status: [.disabled, .disabled, .disabled, .disabled])
]


final class TimeViewModel: BaseViewModel {
    
    // MARK: - Properties
    private let usecaseHost: JoinHostUseCase?
    private let usecaseGuest: JoinGuestUseCase?
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var promiseList = PublishRelay<[PromiseDateViewData]>()
        var naviTitleText = BehaviorRelay<String>(value: "")
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<TimePager>()
    }
    
    init(joinGuestUseCase: JoinGuestUseCase? = nil, joinHostUseCase: JoinHostUseCase? = nil) {
        self.usecaseGuest = joinGuestUseCase
        self.usecaseHost = joinHostUseCase
    }

    // MARK: - Transform
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        if usecaseGuest != nil {  // Guest
            self.handleInputGuest(input, disposeBag: disposeBag)
            return makeOutputGuest(with: input, disposeBag: disposeBag)
        } else {  // Host
            self.handleInputHost(input, disposeBag: disposeBag)
            return makeOutputHost(with: input, disposeBag: disposeBag)
        }
    }
    
    func getHostUsecase() -> JoinHostUseCase {
        return self.usecaseHost!
    }
    
    func getGeustUsecase() -> JoinGuestUseCase {
        return self.usecaseGuest!
    }
    
    func makePromiseList(mode: UserType) -> [PromiseDateViewData] {
        switch mode {
        case .guest:
            return makePromiseDateViewData(start: (usecaseGuest?.startDate)! ,
                                           end: (usecaseGuest?.endDate)!)
        case .host:
            return makePromiseDateViewData(start: (usecaseHost?.startDate)! ,
                                           end: (usecaseHost?.endDate)!)
        }
    }
    
    private func makePromiseDateViewData(start: Date, end: Date) -> [PromiseDateViewData]{
        let dates = datesBetween(start: start, end: end)
        let count = dates.count
        var promiseDateViewData = createArrayWithCount(count)
        for i in 0..<count {
            let date = dates[i]
            promiseDateViewData[i] = PromiseDateViewData(date: date,
                                                         dateLabel: date.formatted("dd(E)"),
                                                         status: [.notSelected, .notSelected, .notSelected, .notSelected])
        }
        return promiseDateViewData
    }
    
    private func datesBetween(start: Date, end: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = start
        while currentDate <= end {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
    
    private func createArrayWithCount(_ count: Int) -> [PromiseDateViewData] {
        let empty = PromiseDateViewData(date: nil, dateLabel: "-", status: [.disabled, .disabled, .disabled, .disabled])
        switch count {
        case 1...4:
            return Array(repeating: empty, count: 4)
        case 5...8:
            return Array(repeating: empty, count: 8)
        case 9...12:
            return Array(repeating: empty, count: 12)
        case 13...14:
            return Array(repeating: empty, count: 16)
        default:
            return []
        }
    }


}

// MARK: - HOST
extension TimeViewModel {
    
    private func handleInputHost(_ input: Input, disposeBag: DisposeBag) {

    }
    
    private func makeOutputHost(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                output.naviTitleText.accept(try! (self?.usecaseHost!.roomName)!.value())
                
                let list = self?.makePromiseDateViewData(start: (self?.usecaseHost!.startDate)!,
                                                   end: (self?.usecaseHost!.endDate)!)
//                output.promiseList.accept(list!)
                output.promiseList.accept(promiseDateMock)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.back)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.place)
            })
            .disposed(by: disposeBag)
        return output
    }
    
}


// MARK: - Guest
extension TimeViewModel {
    
    private func handleInputGuest(_ input: Input, disposeBag: DisposeBag) {

    }
    
    
    private func makeOutputGuest(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                output.naviTitleText.accept((self?.usecaseGuest!.roomName)!)
                
                let list = self?.makePromiseDateViewData(start: (self?.usecaseGuest!.startDate)!,
                                                   end: (self?.usecaseGuest!.endDate)!)
                output.promiseList.accept(promiseDateMock)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.back)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.place)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
        
}

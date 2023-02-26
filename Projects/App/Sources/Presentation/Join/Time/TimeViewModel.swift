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


final class TimeViewModel: BaseViewModel {
    
    // MARK: - Properties
    private let usecaseHost: JoinHostUseCase?
    private let usecaseGuest: JoinGuestUseCase?
    private var promiseList: [PromiseDateViewData] = []
    private var selectedTimes = BehaviorRelay<[SelectedTime]>(value: [])
    private let promiseTimes: [PromiseTime] = [.morning, .lunch, .dinner, .night]
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let timeCellDidTap: Observable<Int>
        let selectedCellDidTap: Observable<Int>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var naviTitleText = BehaviorRelay<String>(value: "")
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<TimePager>()
        var updateSelected = BehaviorRelay<[String]>(value: [])
        var initSelected = BehaviorRelay<[String]>(value: [])
        var diselectTimeCell = PublishRelay<Int>()
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
            promiseList = makePromiseDateViewData(start: (usecaseGuest?.startDate)! ,
                                                  end: (usecaseGuest?.endDate)!)
            return promiseList
        case .host:
            promiseList = makePromiseDateViewData(start: (usecaseHost?.startDate)! ,
                                                  end: (usecaseHost?.endDate)!)
            return promiseList
        }
    }
    
    
    private func getIndex(time: SelectedTime, promiselist: [PromiseDateViewData]) -> Int? {
        for (index, element) in promiselist.enumerated() {
            if element.date?.formatted("yyyy-MM-dd") == time.promiseDate {
                switch time.promiseTime {
                case .morning: return 4 * index
                case .lunch: return 4 * index + 1
                case .dinner: return 4 * index + 2
                case .night: return 4 * index + 3
                }
            }
        }
        return nil
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
        
        input.timeCellDidTap
            .subscribe(onNext: { [weak self] cellNo in
                let date = cellNo / 4
                let time = cellNo % 4
                        
                var timeList: [SelectedTime] = []
                self?.selectedTimes
                    .asDriver()
                    .drive { times in
                        timeList += times
                    }
                    .disposed(by: disposeBag)
                
                let selected = SelectedTime(promiseDate: (self?.promiseList[date].date?.formatted("yyyy-MM-dd"))! ,
                             promiseTime: (self?.promiseTimes[time])!
                )
                
                guard timeList.contains(selected) != true else { return }
                timeList.insert(contentsOf: [selected], at: 0)
                self?.selectedTimes.accept(timeList)
            })
            .disposed(by: disposeBag)
    }
    
    private func makeOutputHost(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                output.naviTitleText.accept(try! (self?.usecaseHost!.roomName)!.value())
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
        
        self.selectedTimes
            .subscribe(onNext: { selecteTimes in
                var timeSelections = [String]()
                
                for time in selecteTimes {
                    timeSelections.append("\(time.promiseDate.toDate()!.formatted("dd(E)")) \(time.promiseTime.toText())")
                }
                output.updateSelected.accept(timeSelections)
                output.nextButtonMakeEnable.accept(selecteTimes.count > 0)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}


// MARK: - Guest
extension TimeViewModel {
    
    private func handleInputGuest(_ input: Input, disposeBag: DisposeBag) {
        
        input.timeCellDidTap
            .subscribe(onNext: { [weak self] cellNo in
                let date = cellNo / 4
                let time = cellNo % 4
                        
                var timeList: [SelectedTime] = []
                self?.selectedTimes
                    .asDriver()
                    .drive { times in
                        timeList += times
                    }
                    .disposed(by: disposeBag)
                
                let selected = SelectedTime(promiseDate: (self?.promiseList[date].date?.formatted("yyyy-MM-dd"))! ,
                             promiseTime: (self?.promiseTimes[time])!
                )
                if timeList.contains(selected) {
                    let idx = timeList.firstIndex(of: selected)
                    timeList.remove(at: idx! )
                } else {
                    timeList.insert(contentsOf: [selected], at: 0)
                }
                self?.selectedTimes.accept(timeList)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func makeOutputGuest(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        /*
        input.selectedCellDidTap
            .subscribe(onNext: { [weak self] in
                var timelist: [SelectedTime] = []
                self?.selectedTimes
                    .asDriver()
                    .drive { times in
                        timelist += times
                    }
                    .disposed(by: disposeBag)

                let timeToRemove = timelist[$0]
                let idx = self?.getIndex(time: timeToRemove,
                                         promiselist: self?.promiseList ?? [])

                output.diselectTimeCell.accept(idx!)

                if timelist.count > 0 {
                    timelist.remove(at: $0)
                    self?.selectedTimes.accept(timelist)
                }

            })
            .disposed(by: disposeBag)
        */
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                output.initSelected.accept([])
                output.naviTitleText.accept((self?.usecaseGuest!.roomName)!)
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
        
        self.selectedTimes
            .subscribe(onNext: { selecteTimes in
                var timeSelections = [String]()
                
                for time in selecteTimes {
                    timeSelections.append("\(time.promiseDate.toDate()!.formatted("dd(E)")) \(time.promiseTime.toText())")
                }
                output.updateSelected.accept(timeSelections)
                output.nextButtonMakeEnable.accept(selecteTimes.count > 0)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
        
}

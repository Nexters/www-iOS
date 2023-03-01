//
//  PlaceVoteViewModel.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxRelay
import RxSwift

final class PlaceVoteViewModel: BaseViewModel {
    
    private let usecase: PlaceVoteUseCase
    private var disposeBag = DisposeBag()
    private let meetingId: Int
    private let meetingStatus: MeetingStatus
    private var placelist: [PlaceVote] = PlaceVote.mockData
    private var myVoteSelection = BehaviorRelay<[PlaceVote]>(value: [])
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let voteCellDidTap: Observable<Int>
        let voteButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var placeVoteList = PublishRelay<[PlaceVote]>()
        var updateSelected = BehaviorRelay<[String]>(value: [])
        var voteButtonMakeCompleted = BehaviorRelay<Bool>(value: false)
    }
    
    init(usecase: PlaceVoteUseCase, roomId: Int, status: MeetingStatus) {
        self.usecase = usecase
        self.meetingId = roomId
        self.meetingStatus = status
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.handleInput(input, disposeBag: disposeBag)
        return makeOutput(with:  input, disposeBag: disposeBag)
    }
    
    private func handleInput(_ input: Input, disposeBag: DisposeBag) {
        input.voteCellDidTap
            .subscribe(onNext: { [weak self] index in

                var voteList: [PlaceVote] = []
                self?.myVoteSelection
                    .asDriver()
                    .drive { votes in
                        voteList += votes
                    }
                    .disposed(by: disposeBag)

                let selected = self!.placelist[index]
                
                if voteList.contains(selected) {
                    let idx = voteList.firstIndex(of: selected)
                    voteList.remove(at: idx!)
                } else {
                    voteList.append(selected)
                }
                print("🥹\(voteList)")
                self?.myVoteSelection.accept(voteList)
            })
            .disposed(by: disposeBag)
    }
    
    private func makeOutput(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .subscribe(onNext: { [weak self] in
                let list = self?.usecase.fetchPlaceVotes(meetingId: self!.meetingId)
                self?.placelist = list ?? []
                output.placeVoteList.accept(list ?? [])
            })
            .disposed(by: disposeBag)
        
        self.myVoteSelection
            .subscribe(onNext: { voteSelections in
                var timeSelections = [String]()
                
//                for time in selecteTimes {
//                    timeSelections.append("\(time.promiseDate.toDate()!.formatted("dd(E)")) \(time.promiseTime.toText())")
//                }
//                output.updateSelected.accept(timeSelections)
//                output.nextButtonMakeEnable.accept(selecteTimes.count > 0)
            })
            .disposed(by: disposeBag)
        
//        input.nextButtonDidTap
//            .subscribe(onNext: {
//                output.navigatePage.accept(.roomMain)
//            })
//            .disposed(by: disposeBag)
        
        self.usecase.isVoted
            .subscribe(onNext: { isVoted in
                output.voteButtonMakeCompleted.accept(isVoted)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}


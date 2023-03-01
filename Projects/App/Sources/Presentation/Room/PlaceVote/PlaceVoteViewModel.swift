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
    private var meetingStatus: MeetingStatus
    private var placelist: [PlaceVote] = []
    private var myVoteSelection: [PlaceVote] = []
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let voteCellDidTap: Observable<Int>
        let voteButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var placeVoteList = PublishRelay<[PlaceVote]>()
        var isVoted = BehaviorRelay<Bool>(value: false)
        var totalVote = PublishRelay<Int>()
        var updateSelected = BehaviorRelay<[String]>(value: [])
        var voteButtonStatus = PublishRelay<MeetingStatus>()
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
                var voteList: [PlaceVote] = self?.myVoteSelection ?? []
                let selected = self!.placelist[index]
                if voteList.contains(selected) {
                    let idx = voteList.firstIndex(of: selected)
                    voteList.remove(at: idx!)
                } else {
                    voteList.append(selected)
                }
                self?.myVoteSelection = voteList
            })
            .disposed(by: disposeBag)
    }
    
    private func makeOutput(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.usecase.fetchPlaceVotes(meetingId: self!.meetingId)
                    .subscribe(onNext: { [weak self] list in
                        self?.placelist = list
                        output.placeVoteList.accept(list)
                    }).disposed(by: disposeBag)
                output.voteButtonStatus.accept(self?.meetingStatus ?? .voted)
            })
            .disposed(by: disposeBag)
        
        input.voteButtonDidTap
            .subscribe(onNext: { [weak self] in
                guard let myvote =  self?.myVoteSelection else { return }
                if myvote.count > 0 {
                    self?.usecase.votePlace(votes: myvote)
                }
            })
            .disposed(by: disposeBag)
        
        self.usecase.isCurrentUserVoted
            .subscribe(onNext: { isVoted in
                if isVoted == true {
                    self.meetingStatus = .voted
                }
                output.voteButtonStatus.accept(self.meetingStatus)
            })
            .disposed(by: disposeBag)
        
        self.usecase.votedUserCount
            .subscribe(onNext: { count in
                output.totalVote.accept(count)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}


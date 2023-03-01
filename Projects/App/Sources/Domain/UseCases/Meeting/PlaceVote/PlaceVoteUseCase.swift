//
//  PlaceVoteUseCase.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift

protocol PlaceVoteUseCaseProtocol {
    var meetingId: Int { get set }
    var isVoted: PublishSubject<Bool> { get } // 나의 투표여부
    var fetchedVotes: [PlaceVote] { get set }
    var votedUserCount: PublishSubject<Int> { get }
}

final class PlaceVoteUseCase: PlaceVoteUseCaseProtocol {
    
    // MARK: - Properties
    internal var meetingId: Int = -1
    var isVoted = PublishSubject<Bool>()
    internal var fetchedVotes: [PlaceVote] = []
    var votedUserCount = PublishSubject<Int>()
    
    private let bag = DisposeBag()
    private let repository: MeetingVoteRepository
    
    
    // MARK: - Methods
    init(repository: MeetingVoteRepository) {
        self.repository = repository
    }

    func fetchPlaceVotes(meetingId: Int) -> Observable<[PlaceVote]> {
        self.repository.fetchVoteUsers(meetingId: meetingId)
            .subscribe(onNext: { [weak self] count in
                self?.votedUserCount.onNext(count)
            })
            .disposed(by: bag)

        return self.repository.fetchPlaceToVoteList(meetingId: meetingId)
            .compactMap({ [weak self] placeVotes in
                self?.fetchedVotes = placeVotes
                let checkMyVoteStatus = self?.containsMyVote(placeVotes)
                if checkMyVoteStatus! {
                    self?.isVoted.onNext(true)
                }
                return placeVotes
            }).asObservable()
    }
    
    /*
     투표하기
     1. /meetings/{meetingId}/votes
     2. 결과 -> 성공적으로 투표되면 투표완료 버튼 비활성화
     
     */
    func votePlace(votes: [PlaceVote]) {
        self.isVoted.onNext(true)
    }
    
}

private extension PlaceVoteUseCase {
    
    func containsMyVote(_ data: [PlaceVote]) -> Bool {
        return data.contains { $0.isMyVote }
    }
}

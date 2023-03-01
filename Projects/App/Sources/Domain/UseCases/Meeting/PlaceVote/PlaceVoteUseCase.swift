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
    var placeList: [PlaceVote] { get set }
}

final class PlaceVoteUseCase: PlaceVoteUseCaseProtocol {
    
    // MARK: - Properties
    internal var meetingId: Int = -1
    var isVoted = PublishSubject<Bool>()
    internal var placeList: [PlaceVote] = []
    
    private let disposeBag = DisposeBag()

    
    // MARK: - Methods
    init() {
//        self.meetingCreateRepository = meetingCreateRepository
    }
    
    /*
     방 초기화 세팅
     1. 방정보를 가져온다. (/meetings/{meetingId})
     2. 나의 투표여부(isVoted)를 체크한다.
     3. 투표선택지와 현재 투표현황을 매핑하여 placeList 만들기
     ( ​/votes​/{meetingId} )
     */
    func fetchPlaceVotes(meetingId: Int) -> [PlaceVote] {
        return PlaceVote.mockData
    }
    
    /*
     투표하기
     1. /meetings/{meetingId}/votes
     2. 결과 -> 성공적으로 투표되면 투표완료 버튼 비활성화
     
     */
    func votePlace(votes: [PlaceVote]) {
        
    }

}

//
//  PlaceVoteDAO.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/02.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift

final class PlaceVoteDAO {
    
    private let network: RxMoyaProvider<VoteAPI>
    private let disposeBag = DisposeBag()
    private var myVotes: [String] = []
    
    init(network: RxMoyaProvider<VoteAPI>) {
        self.network = network
    }
    
    
    // 투표참가인원
    func fetchVoteUsers(meetingId id: Int) -> Observable<Int> {
        return self.network.request(.fetchVoteLists(id: 193))
            .map(PlaceVoteResponseDTO.self)
            .compactMap({ response in
                self.myVotes = response.result.myVoteList
                return response.result.votedUserCount
            }).asObservable()
    }
    
    
    
    
    
}

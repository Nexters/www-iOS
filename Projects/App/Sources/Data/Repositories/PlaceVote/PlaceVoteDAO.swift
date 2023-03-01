//
//  PlaceVoteDAO.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/02.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift

final class PlaceVoteDAO: MeetingVoteRepository {
    
    private let network: RxMoyaProvider<VoteAPI>
    private let disposeBag = DisposeBag()
    
    init(network: RxMoyaProvider<VoteAPI>) {
        self.network = network
    }
    
    func fetchVoteUsers(meetingId id: Int) -> Observable<Int> {
        return self.network.request(.fetchVoteLists(id: 193))
            .map(PlaceVoteResponseDTO.self)
            .compactMap({ response in
                if response.code == 0 {
                    return response.result.votedUserCount
                } else { return -1 } // TODO: 에러처리
            }).asObservable()
    }
    
    func fetchPlaceToVoteList(meetingId id: Int) -> Observable<[PlaceVote]> {
        return self.network.request(.fetchVotePlaces(id: id))
            .map(PlaceVoteItemResponseDTO.self)
            .compactMap { response in
                if response.code == 0 {
                    var placelist: [PlaceVote] = []
                    let myname = UserDefaultKeyCase().getUserName()
                    for place in response.result.userPromisePlaceList {
                        var isMyVote = false
                        for i in place.userInfoList {
                            if i.joinedUserName == myname {
                                isMyVote = true
                            }
                        }
                        placelist += [PlaceVote(id: place.placeID,
                                                placeName: place.promisePlace,
                                                count: place.userInfoList.count,
                                                isMyVote: isMyVote)]
                    }
                    return placelist
                } else { return [] } // TODO: 에러처리
            }
            .asObservable()
    }
    
    
}

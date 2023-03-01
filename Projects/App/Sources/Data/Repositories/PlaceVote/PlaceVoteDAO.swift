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
    
    func postMyVote(meetingId id: Int, votes: [PlaceVote]) -> Observable<Bool> {
        
        let voteIds = votes.map { $0.id }
        
        return self.network.request(.postVote(id: id, dto: PlaceVoteRequestDTO(meetingPlaceIDList: voteIds) ))
            .map(BaseResponseDTO.self)
            .compactMap({ response in
                if response.code == 0 {
                    print("만들엇어요")
                    return true // 성공
                } else {
                    return false // 실패 => TODO: 에러처리
                }
            }).asObservable()
    }
    
    func fetchMyVote(meetingId id: Int) -> Observable<[String]> {
        return self.network.request(.fetchVoteLists(id: id))
            .map(PlaceVoteResponseDTO.self)
            .compactMap({ response in
                if response.code == 0 {
                    return response.result.myVoteList
                } else { return [] } // TODO: 에러처리
            }).asObservable()
    }
    
    func fetchVoteUsers(meetingId id: Int) -> Observable<Int> {
        return self.network.request(.fetchVoteLists(id: id))
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
                    var myVote: [String] = []
                    for place in response.result.userPromisePlaceList {
                        var isMyVote = false
                        let myname = "테스트11"
                        
                        for user in place.userInfoList {
                            if user.joinedUserName == myname {
                                isMyVote = true
                            }
                        }
                        if myVote.contains(place.promisePlace) { isMyVote = true}
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

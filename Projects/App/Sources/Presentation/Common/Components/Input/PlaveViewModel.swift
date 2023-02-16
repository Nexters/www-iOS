//
//  PlaveViewModel.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/16.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

final class PlaceViewModel {
    let local = LocalStorage()
    let server = Server()
    
    private var places: [WrappedPlace] = []
    
    init() {
        self.fetchData()
    }
    
    func fetchData() {
        _ = local.getData()
            .map { places.append(WrappedPlace(isFromLocal: true, place: $0)) }
        _ = server.getDataa()
            .map { places.append(WrappedPlace(isFromLocal: false, place: $0))}
    }
    
    func getPlaces() -> [WrappedPlace] {
        return self.places
    }
}

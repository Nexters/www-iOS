//
//  Place.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/16.
//  Copyright © 2023 com.promise8. All rights reserved.
//


struct Place: Hashable {
    let title: String
}

struct WrappedPlace: Hashable {
    let isFromLocal: Bool
    let place: Place
}

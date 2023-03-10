//
//  Dependencies.swift
//  Config
//
//  Created by Chanhee Jeong on 2023/02/06.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: [
        .remote(
            url: "https://github.com/ReactiveX/RxSwift.git",
            requirement: .upToNextMajor(from: "6.5.0")
        ),
        .remote(
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMajor(from: "5.6.0")
        ),
        .remote(
            url: "https://github.com/Moya/Moya.git",
            requirement: .upToNextMajor(from: "15.0.0")
        ),
        .remote(
            url: "https://github.com/devicekit/DeviceKit.git",
            requirement: .upToNextMajor(from: "4.0.0")
        ),
        .remote(
            url: "https://github.com/airbnb/HorizonCalendar.git",
            requirement: .upToNextMajor(from: "1.16.0")
        ),
        .remote(
            url: "https://github.com/scalessec/Toast-Swift.git",
            requirement: .upToNextMajor(from: "5.0.0")
        )
    ],
    platforms: [.iOS]
)

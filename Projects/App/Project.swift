//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Chanhee Jeong on 2023/02/06.
//

import ProjectDescriptionHelpers
import ProjectDescription

private let projectName = "App"
private let iOSTargetVersion = "15.0"


let project = Project.app(name: projectName,
                          platform: .iOS,
                          iOSTargetVersion: iOSTargetVersion,
                          infoPlist: "Support/Info.plist",
                          dependencies: [
                            .external(name: "RxSwift"),
                            .external(name: "RxCocoa"),
                            .external(name: "RxMoya"),
                            .external(name: "SnapKit"),
                            .external(name: "DeviceKit"),
                            .external(name: "HorizonCalendar")
                          ])

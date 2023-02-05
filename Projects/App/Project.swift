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


let project = Project.makeAppModule(
    name: projectName,
    product: .app,
    dependencies: [],
    resources:  ["Resources/**"],
    infoPlist: .file(path: "Sources/Application/Info.plist")
)

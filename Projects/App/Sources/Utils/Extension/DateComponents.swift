//
//  DateComponents.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/26.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

extension DateComponents {
    
    static func convertTime(_ date: Date) -> Self {
        return .init(
            timeZone: .autoupdatingCurrent,
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: Calendar.current.component(.day, from: Date())
        )
    }
}

//
//  Date+.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/26.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

extension Date {
    /**
     # formatted
     - Note: 입력한 Format으로 변형한 String 반환
     - Parameters:
     - format: 변형하고자 하는 String타입의 Format (ex : "yyyy/MM/dd")
     - Returns: DateFormatter로 변형한 String
     */
    public func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko")
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
        return formatter.string(from: self)
    }
    
    func currentTimeZoneDate() -> Date {
        return Calendar.current.date(from: DateComponents.convertTime(Date())) ?? Date()
    }
}


extension String {
    func strToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)!
    }
}


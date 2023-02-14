//
//  MeetingEnum.swift
//  App
//
//  Created by kokojong on 2023/02/13.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

enum MeetingStatus: String, Codable {
    case confirmed = "CONFIRMED"
    case done = "DONE"
    case voted = "VOTED"
    case voting = "VOTING"
    case waiting = "WAITING"
}

enum PromiseTime: String, Codable {
    case dinner = "DINNER"
    case lunch = "LUNCH"
    case morning = "MORNING"
    case night = "NIGHT"
}

extension PromiseTime {
    func toText() -> String {
        switch self {
        case .dinner:
            return "저녁"
        case .lunch:
            return "점심"
        case .morning:
            return "아침"
        case .night:
            return "밤"
        }
    }
}

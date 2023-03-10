//
//  MeetingEnum.swift
//  App
//
//  Created by kokojong on 2023/02/13.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import UIKit

enum MeetingStatus: String, Codable {
    case confirmed = "CONFIRMED" // 확정된 약속
    case done = "DONE" // 종료된 약속(지나감)
    case voted = "VOTED"
    case voting = "VOTING"
    case waiting = "WAITING"
}

extension MeetingStatus {
    func toText(_ date: Date?) -> String {
        switch self {
        case .confirmed:
            return "\(calculateDday(date))"
        case .done:
            return "\(calculateDday(date))"
        case .voted:
            return "투표 종료"
        case .voting:
            return "투표중"
        case .waiting:
            return "투표 시작 전"
        }
    }

    private func calculateDday(_ date: Date?) -> String {
        
        guard let date = date else { return "" }
        
        let now = Date().formatted("yyyy-MM-dd").toDate()!
        let interval = Calendar.current.dateComponents([.day], from: now, to: date).day ?? 0
        var resultStr = ""
        
        if interval > 0 {
            resultStr = "D-\(interval)"
        } else if interval == 0 {
            resultStr = "D-Day"
        } else {
            resultStr = "D+\(abs(interval))"
        }
        return resultStr
    }
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
            return "저녁🌙"
        case .lunch:
            return "낮🔅"
        case .morning:
            return "아침🥚"
        case .night:
            return "밤🍻"
        }
    }
}

enum YaksokiType: String, Codable {
    case eat = "EAT"
    case play = "PLAY"
    case rest = "REST"
    case work = "WORK"
    
    func toImg() -> UIImage {
        switch self {
        case .eat:
            return UIImage(WWWAssset.yaksoki_eat)!
        case .play:
            return UIImage(WWWAssset.yaksoki_play)!
        case .rest:
            return UIImage(WWWAssset.yaksoki_rest)!
        case .work:
            return UIImage(WWWAssset.yaksoki_work)!
        }
    }
}

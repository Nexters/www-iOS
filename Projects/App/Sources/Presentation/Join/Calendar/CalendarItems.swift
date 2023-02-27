//
//  CalendarItems.swift
//  App
//
//  Created by kokojong on 2023/02/23.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import HorizonCalendar

// MARK: 월 표기 label
struct MonthLabel: CalendarItemViewRepresentable {
    
    typealias ViewType = UILabel
    typealias ViewModel = Content
    
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        let font: UIFont
        var textColor: UIColor
    }
    
    /// Properties that will vary depending on the particular date being displayed.
    struct Content: Equatable {
        let month: Month
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> ViewType
    {
        let label = UILabel()
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        label.backgroundColor = .white
        
        label.textAlignment = .left
        label.clipsToBounds = true
        label.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        
        return label
    }
    
    static func setViewModel(_ viewModel: Content, on view: ViewType) {
        view.text = "\(viewModel.month.year).\(String(format: "%02d", viewModel.month.month))"
    }
    
}

// MARK: 달력 날짜 표기
struct DayLabel: CalendarItemViewRepresentable {
    
    typealias ViewType = UILabel
    
    typealias ViewModel = Content
    
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        let font: UIFont
        var textColor: UIColor
        var backgroundColor: UIColor
    }
    
    /// Properties that will vary depending on the particular date being displayed.
    struct Content: Equatable {
        let day: Day
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> ViewType
    {
        let label = UILabel()
        
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        
        label.textAlignment = .center
        label.clipsToBounds = true
        let itemSize = (WINDOW_WIDTH - 20*2 - 6*10) / 7
        label.layer.cornerRadius = itemSize/2
        
        return label
    }
    
    static func setViewModel(_ viewModel: Content, on view: ViewType) {
        view.text = "\(viewModel.day.day)"
    }
    
}

// MARK: 달력 범위 선택
final class DayRangeIndicatorView: UIView {
    
    private let indicatorColor: UIColor
    
    init(indicatorColor: UIColor) {
        self.indicatorColor = indicatorColor
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    var framesOfDaysToHighlight = [CGRect]() {
        didSet {
            guard framesOfDaysToHighlight != oldValue else { return }
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(indicatorColor.cgColor)
        
        // Get frames of day rows in the range
        var dayRowFrames = [CGRect]()
        if dayRowFrames.count == 1 { return }
        
        var currentDayRowMinY: CGFloat?
        for dayFrame in framesOfDaysToHighlight {
            if dayFrame.minY != currentDayRowMinY {
                currentDayRowMinY = dayFrame.minY
                dayRowFrames.append(dayFrame)
            } else {
                let lastIndex = dayRowFrames.count - 1
                dayRowFrames[lastIndex] = dayRowFrames[lastIndex].union(dayFrame)
            }
        }
        
        let maxIndex = dayRowFrames.count - 1
        
        if dayRowFrames.count == 1 {
            var roundedRectanglePath = UIBezierPath()
            roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrames.first!, cornerRadius: 30)
            context?.addPath(roundedRectanglePath.cgPath)
            context?.fillPath()
        } else {
            dayRowFrames.enumerated().forEach { index, dayRowFrame in
                var roundedRectanglePath = UIBezierPath().cgPath
                
                if index == 0 {
                    roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: .init(width: 30, height: 30)).cgPath
                    
                    let rounded6 = UIBezierPath(roundedRect: dayRowFrame, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: .init(width: 6, height: 6)).cgPath
                    
                    if #available(iOS 16.0, *) {
                        roundedRectanglePath = roundedRectanglePath.intersection(rounded6)   
                    }
                } else if index == maxIndex {
                    roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: .init(width: 30, height: 30)).cgPath
                    let rounded6 = UIBezierPath(roundedRect: dayRowFrame, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: .init(width: 6, height: 6)).cgPath
                    if #available(iOS 16.0, *) {
                        roundedRectanglePath = roundedRectanglePath.intersection(rounded6)
                    }
                } else {
                    roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, cornerRadius: 6).cgPath
                }
                
                context?.addPath(roundedRectanglePath)
                context?.fillPath()
            }
        }
        
        
    }
    
}

// MARK: 달력 범위 선택
extension DayRangeIndicatorView: CalendarItemViewRepresentable {
    
    typealias ViewType = DayRangeIndicatorView
    
    typealias ViewModel = Content
    
    
    struct InvariantViewProperties: Hashable {
        let indicatorColor = UIColor.wwwColor(.WWWGreen).withAlphaComponent(0.35)
    }
    
    struct Content: Equatable {
        let framesOfDaysToHighlight: [CGRect]
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> DayRangeIndicatorView
    {
        DayRangeIndicatorView(indicatorColor: invariantViewProperties.indicatorColor)
    }
    
    static func setViewModel(_ viewModel: Content, on view: DayRangeIndicatorView) {
        view.framesOfDaysToHighlight = viewModel.framesOfDaysToHighlight
    }
    
}


// MARK: 상단 요일
struct MonthDayLabel: CalendarItemViewRepresentable {
    
    typealias ViewType = UILabel
    
    typealias ViewModel = Content
    
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        let font: UIFont
        let backgroundColor: UIColor
    }
    
    /// Properties that will vary depending on the particular date being displayed.
    struct Content: Equatable {
        let dayOfWeek: DayOfWeek
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> ViewType
    {
        let label = UILabel()
        
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.font = invariantViewProperties.font
        
        label.textAlignment = .center
        return label
    }
    
    static func setViewModel(_ viewModel: Content, on view: ViewType) {
        view.text = viewModel.dayOfWeek.text
        if viewModel.dayOfWeek == .sun {
            view.textColor = .wwwColor(.WWWRed)
        } else {
            view.textColor = .wwwColor(.Gray300)
        }
    }
    
    enum DayOfWeek: Int {
        case sun = 0
        case mon
        case tue
        case wed
        case thr
        case fri
        case sat
        
        var text: String {
            switch self {
            case .sun: return "일"
            case .mon: return "월"
            case .tue: return "화"
            case .wed: return "수"
            case .thr: return "목"
            case .fri: return "금"
            case .sat: return "토"
            }
        }
    }
    
}



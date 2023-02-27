//
//  CalendarViewController.swift
//  App
//
//  Created by kokojong on 2023/02/22.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import HorizonCalendar

final class CalendarViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: CalendarViewModel?
    private var selectedStartDay: Day? = nil
    private var selectedEndDay: Day? = nil
    private var defaultDate = Date()
    
    // MARK: - UI
    private let progressView = ProgressView(current: 4, total: 6)
    
    private let titleView = BasicTitleView(title: "약속 날짜의 범위를 정해주세요.",
                                           subTitle: "약속 날짜 범위 내에서 가능한 날짜를 투표하게 됩니다.")
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("다음", for: .normal)
        $0.setButtonState(true) // TODO: 화면 전환 연결용 -> 삭제
        return $0
    }(LargeButton(state: false))
    
    lazy var calendarView = CalendarView(initialContent: makeContent())
    
    // MARK: - LifeCycle
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configUI()
        setNavigationBar(title: "캘린더")
        bindVM()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
        self.view.addSubview(calendarView)
        calendarView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    private func configUI() {
        titleView.backgroundColor = .wwwColor(.WWWWhite)
        
        calendarView.backgroundColor = .wwwColor(.WWWWhite)
        calendarView.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self else { return }
            // 1. 아무것도 선택x -> 둘다 nil(selectedStartDay nil) -> start == end 선택
            if self.selectedStartDay == nil {
                self.selectedStartDay = day
                self.selectedEndDay = day
                self.titleView.subtitleLabel.text =
                "\(self.selectedStartDay) - "
                self.nextButton.setButtonState(false)
            } // 2. 하나 선택 -> 둘다 nil이 아니고 같음 -> start~end 선택
            else if self.selectedStartDay == self.selectedEndDay {
                if self.isAfter14Days(from: self.selectedStartDay, to: day) {
                    // TODO: Toast 띄우기
                    print("14일 이내만 가능")
                    "\(self.selectedStartDay) - "
                    self.nextButton.setButtonState(false)
                } else {
                    self.selectedEndDay = day
                    self.titleView.subtitleLabel.text = "\(self.selectedStartDay) - \(self.selectedEndDay)"
                    self.nextButton.setButtonState(true)
                }
            } // 3. 둘다 선택 -> 둘다 nil이 아니고 다름 -> start, end nil로 만듬
            else {
                self.selectedStartDay = nil
                self.selectedEndDay = nil
                self.titleView.subtitleLabel.text = "약속 날짜 범위 내에서 가능한 날짜를 투표하게 됩니다."
                self.nextButton.setButtonState(false)
            }
            
            let newContent = self.makeContent()
            self.calendarView.setContent(newContent)
        }
    }
    
    private func setNavigationBar(title: String = "") {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(.chevron_left), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .black
        let progressLabel = UILabel()
        progressLabel.text = "4/6"
        progressLabel.textColor = .wwwColor(.WWWBlack)
        progressLabel.font = UIFont.www.body3
        let progressItem: UIBarButtonItem = UIBarButtonItem(customView: progressLabel)
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .www.title8
        titleLabel.textColor = .wwwColor(.WWWBlack)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = progressItem
        navigationItem.titleView = titleLabel
    }
    
    @objc func backButtonDidTap() { // TODO: 임시
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setAction() {
        nextButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let viewmodel = TimeViewModel(joinHostUseCase: self!.viewModel.getUseCase())
                self?.navigationController?.pushViewController(TimeViewController(viewmodel: viewmodel, userMode: .host), animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindRx() {
        
    private func bindVM() {
//        let output = viewModel?.transform(input: .init(
//            viewDidLoad: Observable.just(()),
//            nextButtonDidTap: Observable.just(()),
//            backButtonDidTap: Observable.just(()),
//            selectStartDate: <#T##Observable<Date>#>,
//            selectEndDate: <#T##Observable<Date>#>), disposeBag: bag)
    }
    
    private func isAfter14Days(from start: Day?, to end: Day?) -> Bool {
        print(start, end)
        print(start?.day, end?.day)
        if end!.day > start!.day + 14 {
            return true
        }
        // TODO: day -> Date , 14일 계산
        return false
    }
}

extension CalendarViewController {
    private func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day], from: Date.now)
        
        defaultDate = calendar.date(from: DateComponents(year: components.year! - 1, month: components.month, day: components.day))! // 1년전 날짜
    
        let visibleStartDate = calendar.date(from: DateComponents(year: components.year, month: components.month, day: components.day))!
        
        let visibleEndDate = calendar.date(from: DateComponents(year: components.year!, month: components.month! + 11, day: components.day))! // 1년으로 제한
                                             
        let visibleDateRange: ClosedRange<Date> = visibleStartDate...visibleEndDate
        
        var startDate: Date = defaultDate
        if let selectedStartDay {
            startDate = calendar.date(from: DateComponents(year: selectedStartDay.month.year, month: selectedStartDay.month.month, day: selectedStartDay.day))!
        }
        
        var endDate: Date = defaultDate
        if let selectedEndDay {
            endDate = calendar.date(from: DateComponents(year: selectedEndDay.month.year, month: selectedEndDay.month.month, day: selectedEndDay.day))!
        }
        
        var selectedDateRange: ClosedRange<Date> = ClosedRange<Date>(uncheckedBounds: (lower: startDate, upper: endDate))
            selectedDateRange = startDate...endDate
        
      return CalendarViewContent(
        calendar: calendar,
        visibleDateRange: visibleDateRange,
        monthsLayout: .vertical(options: VerticalMonthsLayoutOptions(pinDaysOfWeekToTop: true)))
      .verticalDayMargin(10)
      .horizontalDayMargin(10)
      .monthDayInsets(UIEdgeInsets.zero)
      .daysOfTheWeekRowSeparator(options: CalendarViewContent.DaysOfTheWeekRowSeparatorOptions(height: 1, color: .wwwColor(.Gray150)))
        // MARK: 월 표기 label
      .monthHeaderItemProvider({ month in
          return MonthLabel.calendarItemModel(invariantViewProperties: MonthLabel.InvariantViewProperties.init(font: .www.title5!, textColor: .wwwColor(.WWWBlack)), viewModel: .init(month: month))
      })
        // MARK: 날짜 label
      .dayItemProvider { [weak self] day in
          var properties = DayLabel.InvariantViewProperties(font: .www.body3!, textColor: .wwwColor(.WWWBlack), backgroundColor: .clear)
          if self?.selectedStartDay == day || self?.selectedEndDay == day {
              properties.textColor = .wwwColor(.WWWWhite)
              properties.backgroundColor = .wwwColor(.WWWGreen)
          } else {
              properties.textColor = .wwwColor(.WWWBlack)
              properties.backgroundColor = .clear
          }
          
        return DayLabel.calendarItemModel(invariantViewProperties: properties, viewModel: .init(day: day))
      }
        // MARK: 요일 label
      .dayOfWeekItemProvider { month, weekdayIndex in
          let properties = MonthDayLabel.InvariantViewProperties(font: .www.body4!, backgroundColor: .wwwColor(.WWWWhite))
          
          return MonthDayLabel.calendarItemModel(invariantViewProperties: properties, viewModel: .init(dayOfWeek: MonthDayLabel.DayOfWeek(rawValue: weekdayIndex)!))
      }
        // MARK: 날짜 범위 선택
      .dayRangeItemProvider(for: [selectedDateRange]) { dayRangeLayoutContext in
          DayRangeIndicatorView.calendarItemModel(invariantViewProperties: .init(), viewModel: .init(framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
      }
      
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct CalendarViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        let viewModel = CalendarViewModel(usecaseHost: JoinHostUseCase())
//        CalendarViewController(viewModel: viewModel).toPreview()
//    }
//}
#endif

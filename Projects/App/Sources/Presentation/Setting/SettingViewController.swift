//
//  SettingViewController.swift
//  App
//
//  Created by kokojong on 2023/02/24.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: SettingViewModel?
    
    // MARK: - UI
    private let stackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.contentMode = .top
        stv.distribution = .equalSpacing
        stv.spacing = 0
        return stv
    }()
    
    private let pushAlarmView: UIView = {
        let view = UIView()
        view.snp.makeConstraints {
            $0.height.equalTo(58)
        }
        return view
    }()
    
    private let pushAlarmTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "푸시 알림 설정"
        label.font = .www.title9
        label.textColor = .wwwColor(.WWWBlack)
        label.textAlignment = .left
        return label
    }()
    
    private let pushAlarmSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.onTintColor = .wwwColor(.WWWGreen)
        toggleSwitch.isOn = UserDefaultKeyCase().getIsPushAlarmOn()
        return toggleSwitch
    }()
    
    private let appVersionView: UIView = {
        let view = UIView()
        view.snp.makeConstraints {
            $0.height.equalTo(58)
        }
        return view
    }()
    
    private let appVersionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 버전"
        label.font = .www.title9
        label.textColor = .wwwColor(.WWWBlack)
        label.textAlignment = .left
        return label
    }()
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        label.text = "1.0.0"
        label.font = .www(size: 14, family: .Regular)
        label.textColor = .wwwColor(.Gray350)
        label.textAlignment = .center
        return label
    }()
    
    private let devInfoView: UIView = {
        let view = UIView()
        view.snp.makeConstraints {
            $0.height.equalTo(58)
        }
        return view
    }()
    
    private let devInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "개발자 정보"
        label.font = .www.title9
        label.textColor = .wwwColor(.WWWBlack)
        label.textAlignment = .left
        return label
    }()
    
    private let devInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "www@gmail.com"
        label.font = .www(size: 14, family: .Regular)
        label.textColor = .wwwColor(.Gray350)
        label.textAlignment = .center
        return label
    }()
    
    private let feedbackView: UIView = {
        let view = UIView()
        view.snp.makeConstraints {
            $0.height.equalTo(58)
        }
        return view
    }()
    
    private let feedbackLabel: UILabel = {
        let label = UILabel()
        label.text = "피드백 남기기"
        label.font = .www.title9
        label.textColor = .wwwColor(.WWWBlack)
        label.textAlignment = .left
        return label
    }()
    
    private let privacyView: UIView = {
        let view = UIView()
        view.snp.makeConstraints {
            $0.height.equalTo(58)
        }
        return view
    }()
    
    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보 처리방침"
        label.font = .www.title9
        label.textColor = .wwwColor(.WWWBlack)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - LifeCycle
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        setNavigationBar(title: "설정")
    }
    
    private func setUI() {
        self.view.backgroundColor = .wwwColor(.WWWWhite)
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        stackView.addArrangedSubviews(pushAlarmView, appVersionView, devInfoView, feedbackView, privacyView)
        
        pushAlarmView.addSubviews(pushAlarmTitleLabel, pushAlarmSwitch)
        pushAlarmTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        pushAlarmSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pushAlarmTitleLabel.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        appVersionView.addSubviews(appVersionTitleLabel, appVersionLabel)
        appVersionTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        appVersionLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        appVersionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(appVersionTitleLabel.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        devInfoView.addSubviews(devInfoTitleLabel, devInfoLabel)
        devInfoTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        devInfoLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        devInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(devInfoTitleLabel.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        feedbackView.addSubview(feedbackLabel)
        feedbackLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        privacyView.addSubview(privacyLabel)
        privacyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    private func bindViewModel() {
        let input = SettingViewModel.Input(togglePushAlarm: pushAlarmSwitch.rx.isOn.asObservable())
        
        let output = viewModel?.transform(input: input, disposeBag: bag)
        
        output?.isPushAlarmOn.subscribe(onNext: { [weak self] isOn in
            self?.pushAlarmSwitch.isOn = isOn
        }).disposed(by: bag)
    }
    
    private func setNavigationBar(title: String = "") {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(.chevron_left), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .black
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .www.title8
        titleLabel.textColor = .wwwColor(.WWWBlack)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = titleLabel
    }
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SettingViewController_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = SettingViewModel()
        SettingViewController(viewModel: viewModel).toPreview()
    }
}
#endif

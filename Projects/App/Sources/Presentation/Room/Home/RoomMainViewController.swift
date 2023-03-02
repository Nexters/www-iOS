//
//  RoomMainViewController.swift
//  App
//
//  Created by kokojong on 2023/02/28.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import RxSwift

final class RoomMainViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: RoomHomeViewModel
    var voteDict: [String: Int] = [:]
    var whenRank1Count = -1
    var whenRank2Count = -1
    var whenRank3Count = -1
    var whereRank1Count = -1
    var whereRank2Count = -1
    var whereRank3Count = -1
    
    lazy var fetchedMainRoomMeetingInfo: MainRoomMeetingInfo = MainRoomMeetingInfo.emtpyData
    
    // MARK: - UI
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .wwwColor(.Gray50)
        return scrollView
    }()
    
    private let contentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .wwwColor(.Gray50)
        view.distribution = .fillProportionally
        view.alignment = .center
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.setRoundCorners([.bottomLeft, .bottomRight], radius: 30)
        let gradient = UIImageView(image: UIImage(.gradient_room))
        gradient.contentMode = .scaleAspectFill
        view.addSubview(gradient)
        gradient.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(WINDOW_WIDTH)
            $0.height.equalTo(235.verticallyAdjusted)
        }
        view.snp.makeConstraints {
            $0.width.equalTo(WINDOW_WIDTH)
            $0.height.equalTo(235.verticallyAdjusted)
        }
        return view
    }()
    
    private let usersLabel: UILabel = {
        let label = UILabel()
        label.text = "5/8명 입장 중"
        label.font = .www.body5
        label.textColor = .wwwColor(.Gray600)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "연남동 빵집 투어"
        label.font = .www.heading3
        label.textColor = .wwwColor(.WWWBlack)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let yaksokiImgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(.yaksoki_eat)
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let whenContainerView: UIView = {
        let view = UIView()
        view.snp.makeConstraints {
            $0.height.equalTo(44 + 28)
            $0.width.equalTo(WINDOW_WIDTH-40)
        }
        return view
    }()
    
    private let whenTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "언제"
        label.font = .www.title3
        label.textColor = .wwwColor(.WWWBlack)
        label.textAlignment = .left
        return label
    }()
    
    private let whenArrowButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(.chevron_right), for: .normal)
        return btn
    }()
    
    private let whereContainerView: UIView = {
        let view = UIView()
        view.snp.makeConstraints {
            $0.height.equalTo(44 + 28)
            $0.width.equalTo(WINDOW_WIDTH-40)
        }
        return view
    }()
    
    private let whereTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "어디서"
        label.font = .www.title3
        label.textColor = .wwwColor(.WWWBlack)
        label.textAlignment = .left
        return label
    }()
    
    private let whereArrowButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(.chevron_right), for: .normal)
        return btn
    }()
    
    private let whenTableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let whereTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    // MARK: - Life Cycle
    init(viewModel: RoomHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.setUI()
        self.setNavigationBar()
        bindViewModel()
    }
    
    private func setUI() {
        self.view.backgroundColor = .wwwColor(.Gray50)
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.width.edges.equalTo(scrollView)
        }
        
        contentView.addArrangedSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        headerView.addSubview(yaksokiImgView)
        yaksokiImgView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.size.equalTo(200)
        }
        
        headerView.addSubview(usersLabel)
        usersLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(usersLabel.snp.bottom).offset(3)
        }
        
        self.contentView.addArrangedSubview(whenContainerView)
        
        whenContainerView.addSubview(whenTitleLabel)
        whenTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        
        whenContainerView.addSubview(whenArrowButton)
        whenArrowButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(whenTitleLabel)
        }
        
        self.contentView.addArrangedSubview(whenTableView)
        whenTableView.snp.makeConstraints {
            $0.height.equalTo(500)
        }
        
        self.contentView.addArrangedSubview(whereContainerView)
        whereContainerView.addSubview(whereTitleLabel)
        whereTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        
        whereContainerView.addSubview(whereArrowButton)
        whereArrowButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(whereTitleLabel)
        }
        
        //
        self.contentView.addArrangedSubview(whereTableView)
        whereTableView.snp.makeConstraints {
            $0.height.equalTo(500)
        }
        
        
    }
    
    private func setTableView() {
        [whenTableView, whereTableView].forEach { tableView in
            tableView.delegate = self
            tableView.dataSource = self
            tableView.showsVerticalScrollIndicator = false
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.isScrollEnabled = false
            tableView.isUserInteractionEnabled = false
            tableView.layer.applyFigmaShadow(color: .black, opacity: 0.05, x: 0, y: 0, blur: 20, spread: 0)
            tableView.snp.makeConstraints {
                $0.width.equalTo(WINDOW_WIDTH - 40)
            }
        }
        
        whenTableView.register(RoomHomeTimetablesCell.self, forCellReuseIdentifier: RoomHomeTimetablesCell.id)
        whereTableView.register(RoomHomeVotesCell.self, forCellReuseIdentifier: RoomHomeVotesCell.id)
    }
    
    private func bindViewModel() {
        let input = RoomHomeViewModel.Input(viewDidLoad: Observable.just(()))
        
        let output = viewModel.transform(input: input, disposeBag: bag)
        
        output.mainRoomMeetingInfo
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.fetchedMainRoomMeetingInfo = $0
                
                self?.voteDict = [:]
                let userVoteList = $0.userVoteList
                userVoteList.forEach { vote in
                    self?.voteDict[vote.location] = vote.users.count
                }
                self?.whenRank1Count = -1
                self?.whenRank2Count = -1
                self?.whenRank3Count = -1
                
                $0.userPromiseDateTimeList.forEach {
                    let cnt = $0.userInfoList.count
                    if self?.whenRank1Count ?? -1 < 0 {
                        self?.whenRank1Count = cnt
                    } else if self?.whenRank2Count ?? -1 < 0 && cnt < self?.whenRank1Count ?? -1 {
                        self?.whenRank2Count = cnt
                    } else if self?.whenRank3Count ?? -1 < 0 && cnt < self?.whenRank2Count ?? -1 {
                        self?.whenRank3Count = cnt
                    }
                }
                
                self?.whereRank1Count = -1
                self?.whereRank2Count = -1
                self?.whereRank3Count = -1
                
                $0.userPromiseDateTimeList.forEach {
                    let cnt = $0.userInfoList.count
                    if self?.whereRank1Count ?? -1 < 0 {
                        self?.whereRank1Count = cnt
                    } else if self?.whereRank2Count ?? -1 < 0 && cnt < self?.whereRank1Count ?? -1 {
                        self?.whereRank2Count = cnt
                    } else if self?.whereRank3Count ?? -1 < 0 && cnt < self?.whereRank2Count ?? -1 {
                        self?.whereRank3Count = cnt
                    }
                }
                
                self?.fetchUI(data: $0)
            }).disposed(by: bag)
    }
    
    private func setNavigationBar() {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(.chevron_left), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = title
    }
    
    @objc func backButtonDidTap() {}
    
    private func fetchUI(data: MainRoomMeetingInfo) {
        
        titleLabel.text = data.meetingName
        usersLabel.text = "\(data.joinedUserCount)/\(data.minimumAlertMembers)명 입장 중"
        yaksokiImgView.image = data.yaksokiType.toImg()
        
        let whenHeight = data.userPromiseDateTimeList.count * 60 + 52
        self.whenTableView.snp.updateConstraints({ make in
            make.height.equalTo(whenHeight)
        })
        self.whenTableView.reloadData()
        
        let whereHeight = data.userPromisePlaceList.count * 60 + 52
        self.whereTableView.snp.updateConstraints({ make in
            make.height.equalTo(whereHeight)
        })
        self.whereTableView.reloadData()
    }
}

extension RoomMainViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0 + 1.0
    }
}

extension RoomMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == whenTableView {
            return fetchedMainRoomMeetingInfo.userPromiseDateTimeList.count
        } else {
            return fetchedMainRoomMeetingInfo.userPromisePlaceList.count
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == whenTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomHomeTimetablesCell.id, for: indexPath)
                    as? RoomHomeTimetablesCell else { return UITableViewCell() }
            if fetchedMainRoomMeetingInfo.userPromiseDateTimeList.count > 0 {
                let timeInfo = fetchedMainRoomMeetingInfo.userPromiseDateTimeList[indexPath.row]
                var rank = -1
                let count = timeInfo.userInfoList.count
                if count == whenRank1Count {
                    rank = 1
                    whenRank1Count = -1
                } else if count == whenRank2Count {
                    rank = 2
                    whenRank2Count = -1
                } else if count == whenRank3Count {
                    rank = 3
                    whenRank3Count = -1
                }
                
                let title = "\(timeInfo.promiseDate.toDate()!.formatted("yy.MM.dd"))" + " \(timeInfo.promiseDayOfWeek)" + "  \(timeInfo.promiseTime.toText())"
                cell.configure(rank: rank, title: title, count: count, total: fetchedMainRoomMeetingInfo.votingUserCount)
                
            }
            
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomHomeVotesCell.id, for: indexPath)
                    as? RoomHomeVotesCell else { return UITableViewCell() }
            if fetchedMainRoomMeetingInfo.userPromisePlaceList.count > 0 {
                let placeInfo = fetchedMainRoomMeetingInfo.userPromisePlaceList[indexPath.row]
                
                var rank = -1
                let count = placeInfo.userInfoList.count
                if count == whereRank1Count {
                    rank = 1
                    whereRank1Count = -1
                } else if count == whereRank2Count {
                    rank = 2
                    whereRank2Count = -1
                } else if count == whereRank3Count {
                    rank = 3
                    whereRank3Count = -1
                }
                
                
                cell.configure(rank: rank, title: placeInfo.promisePlace, count: placeInfo.userInfoList.count, total: fetchedMainRoomMeetingInfo.votingUserCount)
            }
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") ?? UITableViewHeaderFooterView()
        headerView.contentView.backgroundColor = .white
        headerView.contentView.layer.cornerRadius = 10
        headerView.contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let line = UIView()
        line.backgroundColor = UIColor.wwwColor(.Gray150)
        
        let peopleNumLabel: UILabel = {
            $0.numberOfLines = 0
            $0.textColor = UIColor.wwwColor(.Gray350)
            $0.font = UIFont.www.body6
            $0.text = "N명 참여중"
            return $0
        }(UILabel())
        
        let icon: UIImageView = { // TODO: 아이콘으로 교체
            let imageIcon = UIImage(systemName: "chevron.right")?.withTintColor(.wwwColor(.Gray350), renderingMode: .alwaysOriginal)
            $0.image = imageIcon
            $0.contentMode = .scaleAspectFit
            return $0
        }(UIImageView())
        
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer") ?? UITableViewHeaderFooterView()
        footerView.contentView.backgroundColor = .white
        footerView.contentView.layer.cornerRadius = 10
        footerView.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        footerView.contentView.addSubviews(line, peopleNumLabel, icon)
        line.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        peopleNumLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        icon.snp.makeConstraints { make in
            make.leading.equalTo(peopleNumLabel.snp.trailing).offset(2)
            make.centerY.equalTo(peopleNumLabel.snp.centerY)
            make.width.height.equalTo(14)
        }
        
        peopleNumLabel.text = "\( fetchedMainRoomMeetingInfo.votingUserCount)명 참여"
       
        return footerView
    }
    
    
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct RoomHomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        RoomMainViewController(viewModel: RoomHomeViewModel(mainRoomUseCase: MainRoomUseCase(meetingRoomRepository: MainRoomDAO(network: MeetingAPIManager.provider)))).toPreview()
    }
}
#endif

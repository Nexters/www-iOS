//
//  RoomHomeViewController.swift
//  App
//
//  Created by kokojong on 2023/02/28.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import RxSwift

final class RoomHomeViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: RoomHomeViewModel
    
    // MARK: - UI
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .red
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.setRoundCorners([.bottomLeft, .bottomRight], radius: 30)
//        view.addGradientLayer(colors: [UIColor.wwwColor(.WWWGreen).withAlphaComponent(1).cgColor, UIColor.wwwColor(.WWWWhite).withAlphaComponent(1).cgColor], locations: nil, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
//        view.layoutIfNeeded()
        view.snp.makeConstraints {
            $0.width.equalTo(WINDOW_WIDTH)
            $0.height.equalTo(235)
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
        img.image = UIImage(.monster)
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let whenContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .wwwColor(.Gray50)
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
        view.backgroundColor = .wwwColor(.Gray50)
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
        self.setUI()
        self.setNavigationBar()
        self.setTableView()
        bindViewModel()
    }
    
    private func setUI() {
        self.view.backgroundColor = .wwwColor(.Gray50)
        
        self.view.addSubview(headerView)
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
        
        self.view.addSubview(whenContainerView)
        whenContainerView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
//            $0.bottom.equalToSuperview()
        }
        
        whenContainerView.addSubview(whenTitleLabel)
        whenTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        whenContainerView.addSubview(whenArrowButton)
        whenArrowButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(whenTitleLabel)
        }
        
        self.whenContainerView.addSubview(whenTableView)
        whenTableView.snp.makeConstraints {
            $0.top.equalTo(whenTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(200)
//            $0.bottom.equalToSuperview()
        }
        
        self.view.addSubview(whereContainerView)
        whereContainerView.snp.makeConstraints {
            $0.top.equalTo(whenContainerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        whereContainerView.addSubview(whereTitleLabel)
        whereTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
        }

        whereContainerView.addSubview(whereArrowButton)
        whereArrowButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(whenTitleLabel)
        }

        self.whereContainerView.addSubview(whereTableView)
        whereTableView.snp.makeConstraints {
            $0.top.equalTo(whereTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview()
        }
     
    }
    
    private func setTableView() {
        [whenTableView, whereTableView].forEach { tableView in
            tableView.delegate = self
            tableView.dataSource = self
            tableView.showsVerticalScrollIndicator = false
            tableView.register(PlaceVoteCell.self, forCellReuseIdentifier: PlaceVoteCell.id)
            tableView.backgroundColor = .yellow
            tableView.separatorStyle = .none
            tableView.rowHeight = UITableView.automaticDimension
            tableView.layer.applyFigmaShadow(color: .black, opacity: 0.05, x: 0, y: 0, blur: 20, spread: 0)
        }
    }
    
    private func bindViewModel() {
        
    }
    
    private func setNavigationBar() {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(.chevron_left), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = title
    }
    
    @objc func backButtonDidTap() {}
}

extension RoomHomeViewController: UITableViewDelegate {
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

extension RoomHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceVoteCell.id, for: indexPath)
                as? PlaceVoteCell else { return UITableViewCell() }
        cell.configure(with: "\(indexPath.row)번째 아이템")
        cell.selectionStyle = .none
        return cell
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
        
        return footerView
    }
    
    
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct RoomHomeViewController_Preview: PreviewProvider {
   static var previews: some View {
       RoomHomeViewController(viewModel: RoomHomeViewModel()).toPreview()
   }
}
#endif

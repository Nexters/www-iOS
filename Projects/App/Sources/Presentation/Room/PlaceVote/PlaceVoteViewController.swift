//
//  PlaceVoteViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/21.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class PlaceVoteViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("투표하기", for: .normal)
        $0.setButtonState(true)
        return $0
    }(LargeButton(state: false))
    
    
    // MARK: - LifeCycle
    init() {
        //        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(title: "어디서")
        self.setUI()
        self.setTableView()
    }
    
    
}
// MARK: - Methods
extension PlaceVoteViewController {
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PlaceVoteCell.self, forCellReuseIdentifier: PlaceVoteCell.id)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.layer.applyFigmaShadow(color: .black, opacity: 0.05, x: 0, y: 0, blur: 20, spread: 0)
    }
    
    private func setUI() {
        self.view.backgroundColor = .wwwColor(.WWWWhite)
  
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-88)
        }
        
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    /* Temp */
    private func setNavigationBar(title: String = "") {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(.chevron_left), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = title
    }
    
    @objc func backButtonDidTap() {}
    
}

// MARK: - UITableViewDelegate
extension PlaceVoteViewController: UITableViewDelegate{
    
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

// MARK: - UITableViewDataSource
extension PlaceVoteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceVoteCell.id, for: indexPath)
                as? PlaceVoteCell else { return UITableViewCell() }
//        cell.configure(with: "\(indexPath.row)번째 아이템")
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

struct PlaceVoteViewController_Preview: PreviewProvider {
   static var previews: some View {
//        let viewModel = PlaceViewModel(guest: JoinGuestUseCase())
       PlaceVoteViewController().toPreview()
   }
}
#endif

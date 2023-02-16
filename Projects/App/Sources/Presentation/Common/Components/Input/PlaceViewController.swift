//
//  PlaceViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/16.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

enum Section {
    case place
}

final class PlaceViewController: UIViewController {
    private let viewModel: PlaceViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, WrappedPlace>!
    
    private let progressView = ProgressView(current: 6, total: 6)
    
    private let titleView = BasicTitleView(title: "원하는 장소를 입력해 주세요.",
                                           subTitle: "*필수 항목이 아니에요.")
    
    private lazy var textFieldView = BasicTextFieldView(placeholder: "장소 입력")
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 장소 후보"
        label.textColor = UIColor.wwwColor(.WWWBlack)
        label.numberOfLines = 1
        label.font = UIFont.www.body1
        return label
    }()
    
    private lazy var placeNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor.wwwColor(.WWWGreen)
        label.numberOfLines = 1
        label.font = UIFont.www.body1
        return label
    }()
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("스킵할래요", for: .normal)
        return $0
    }(LargeButton(state: false))
    
    private lazy var chipCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(BasicChipCell.self, forCellWithReuseIdentifier: BasicChipCell.identifier)
        collectionView.register(DeleteChipCell.self, forCellWithReuseIdentifier: DeleteChipCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - LifeCycle
    init(viewModel: PlaceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setDataSource()
        self.setSnapShot()
    }
    
    private func setUI() {
        self.view.backgroundColor = .wwwColor(.WWWWhite)
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        self.view.addSubview(textFieldView)
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
        self.view.addSubview(placeLabel)
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(textFieldView.snp.bottom).offset(64)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }
        
        self.view.addSubview(placeNumberLabel)
        placeNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(placeLabel.snp.trailing).offset(4)
            $0.top.equalTo(placeLabel.snp.top)
            $0.height.equalTo(22)
        }
        
        self.view.addSubview(chipCollectionView)
        chipCollectionView.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().offset(20)
            $0.height.equalTo(34)
        }
        
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    /* Temp */
    private func setNavigationBar(title: String = "") {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(.chevron_left), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .black
        let progressLabel = UILabel()
        progressLabel.text = "1/4"
        progressLabel.font = UIFont.www.body3
        let progressItem: UIBarButtonItem = UIBarButtonItem(customView: progressLabel)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = progressItem
        navigationItem.title = title
    }
    
    @objc func backButtonDidTap() {}
}

// MARK: - Privates

private extension PlaceViewController {
    func setDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, WrappedPlace>(collectionView: self.chipCollectionView) { (collectionView, indexPath, place: WrappedPlace) -> UICollectionViewCell? in
            if place.isFromLocal {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeleteChipCell.identifier, for: indexPath)
                        as? DeleteChipCell else {
                    return UICollectionViewCell()
                }
                cell.configure(place.place.title)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicChipCell.identifier, for: indexPath)
                        as? BasicChipCell else {
                    return UICollectionViewCell()
                }
                cell.configure(place.place.title)
                return cell
            }
        }
    }
    
    func setSnapShot() {
        let places = self.viewModel.getPlaces()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, WrappedPlace>()
        snapshot.appendSections([.place])
        snapshot.appendItems(places)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}


// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PlaceViewController_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = PlaceViewModel()
        PlaceViewController(viewModel: viewModel).toPreview()
    }
}
#endif

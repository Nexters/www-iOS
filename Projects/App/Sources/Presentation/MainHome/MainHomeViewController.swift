//
//  MainHomeViewController.swift
//  App
//
//  Created by kokojong on 2023/02/12.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class MainHomeViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: MainHomeViewModel?
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "WWW"
        label.font = UIFont.www(size: 24, family: .Bold)
        label.textColor = .wwwColor(.WWWBlack)
        return label
    }()
    
    private let promiseButtonTabStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        return stackView
    }()
    
    private let proceedingPromiseButton: UIButton = {
        let button = UIButton()
        button.setTitle("진행 중 약속", for: .normal)
        button.setTitleColor(.wwwColor(.WWWBlack), for: .normal)
        return button
    }()
    
    private let endedPromiseButton: UIButton = {
        let button = UIButton()
        button.setTitle("종료된 약속", for: .normal)
        button.setTitleColor(.wwwColor(.WWWBlack), for: .normal)
        return button
    }()
    
    private let promiseContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .wwwColor(.Gray100) // TODO: - color 추가하거나 문의하기
        return view
    }()
    
    private let emptyPromiseView = MainHomeEmptyPromiseView(message: "아직 진행 중인 약속이 없어요!")
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = .init(width: WINDOW_WIDTH, height: 500)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .yellow
        collectionView.backgroundColor = .wwwColor(.Gray200)
        collectionView.isPagingEnabled = true
        collectionView.register(MainHomePromiseCell.self, forCellWithReuseIdentifier: MainHomePromiseCell.identifier)
//        collectionView.isHidden = true
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Int> = UICollectionViewDiffableDataSource<Section, Int>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in // TODO: entity로 수정
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHomePromiseCell.identifier, for: indexPath) as?  MainHomePromiseCell else { return UICollectionViewCell() }
        cell.setData(data: itemIdentifier)
        return cell
    })
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .wwwColor(.WWWBlack)
        button.clipsToBounds = true
        button.setImage(UIImage(.add), for: .normal)
        button.layer.cornerRadius = 64/2
        return button
    }()
    
    private let dimView = MainHomeDimView()
    
    init(viewModel: MainHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        applyData()
        bindRx()
    }
}

extension MainHomeViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor.wwwColor(.WWWWhite)
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(20)
        }
        
        self.view.addSubview(promiseButtonTabStackView)
        promiseButtonTabStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        promiseButtonTabStackView.addArrangedSubviews(proceedingPromiseButton, endedPromiseButton)
        
        self.view.addSubview(promiseContentView)
        promiseContentView.snp.makeConstraints {
            $0.top.equalTo(promiseButtonTabStackView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        promiseContentView.addSubview(emptyPromiseView)
        emptyPromiseView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(90)
            $0.centerX.equalToSuperview()
        }
        
        promiseContentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints {
            $0.size.equalTo(64)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
        
        self.view.addSubview(dimView)
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dimView.isHidden = true
        
    }
    
    private func applyData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems([1,2,3])
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func bindRx() {
        let input = MainHomeViewModel.Input(viewDidLoad: Observable.just(()).asObservable())
        
        let output = viewModel?.transform(input: input, disposeBag: bag)
        
        output?.mainHomeMeeting.subscribe(onSuccess: {
            print("mainHomeMeeting",$0)
        }).disposed(by: bag)
        
    }
    
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MainHomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = MainHomeViewModel(mainHomeUseCase: MainHomeUseCase(meetingRepository: MainHomeDAO(network: MeetingAPIManager.provider)))
        MainHomeViewController(viewModel: viewModel).toPreview()
    }
}
#endif

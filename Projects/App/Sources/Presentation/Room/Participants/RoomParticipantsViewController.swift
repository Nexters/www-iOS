//
//  RoomParticipantsViewController.swift
//  App
//
//  Created by kokojong on 2023/02/25.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class RoomParticipantsViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: RoomParticipantsViewModel?
    enum Section: CaseIterable {
        case participants
    }
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: WINDOW_WIDTH, height: 64)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .wwwColor(.WWWWhite)
        collectionView.register(ParticipantCell.self, forCellWithReuseIdentifier: ParticipantCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, User>
    = UICollectionViewDiffableDataSource<Section, User>(
        collectionView: self.collectionView,
        cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ParticipantCell.identifier,
                for: indexPath) as? ParticipantCell else { return UICollectionViewCell() }
            cell.setData(user: itemIdentifier)
            return cell
        })
    
    // MARK: - Life Cycle
    init(viewModel: RoomParticipantsViewModel) {
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
    }
    
    private func setUI() {
        self.view.backgroundColor = .wwwColor(.WWWWhite)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let input = RoomParticipantsViewModel.Input(viewDidLoad: Observable.just(()))
        
        let output = viewModel?.transform(input: input, disposeBag: bag)
        
        output?.participants.subscribe(onNext: { [weak self] participants in
            self?.applyData(items: participants, section: .participants)
        }).disposed(by: bag)
    }
    
    private func applyData(items: [User], section: Section) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([section])
        snapshot.appendItems(items)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

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
        case proceeding
        case ended
    }
    var isOneStepPaging = true
    var currentIndex: CGFloat = 0 {
        didSet {
            pageLabel.customAttributedString(
                text: "\(Int(currentIndex)+1)/5",
                highlightText: "\(Int(currentIndex)+1)",
                textFont: .www(size: 14)!,
                highlightTextFont: .www(size: 14)!,
                textColor: .wwwColor(.Gray450),
                highlightTextColor: .wwwColor(.WWWGreen)
            )
        }
    }
    
    private var fetchedMainHomeMeeting: MainHomeMeeting = .init(proceedingMeetings: [], endedMeetings: [])
    
    // MARK: - UI
    private let titleLabel: UIImageView = {
        let label = UIImageView()
        label.contentMode = .scaleAspectFit
        label.image = UIImage(.logo_type3)
        return label
    }()
    
    private let settingButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(.settings), for: .normal)
        return btn
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
        button.setTitleColor(.wwwColor(.Gray250), for: .normal)
        button.setTitleColor(.wwwColor(.WWWBlack), for: .disabled)
        button.titleLabel?.font = .www(size: 18, family: .Bold)
        button.isEnabled = false
        return button
    }()
    
    private let endedPromiseButton: UIButton = {
        let button = UIButton()
        button.setTitle("종료된 약속", for: .normal)
        button.setTitleColor(.wwwColor(.Gray250), for: .normal)
        button.setTitleColor(.wwwColor(.WWWBlack), for: .disabled)
        button.titleLabel?.font = .www(size: 18, family: .Bold)
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
        
        let cellWidth:CGFloat = WINDOW_WIDTH - 100
        let cellHeight:CGFloat = 500
        
        let insetX = (WINDOW_WIDTH - cellWidth) / 2.0
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = 30
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .wwwColor(.Gray100)
        collectionView.isPagingEnabled = false
        collectionView.register(MainHomePromiseCell.self, forCellWithReuseIdentifier: MainHomePromiseCell.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, MeetingMain>
    = UICollectionViewDiffableDataSource<Section, MeetingMain>(
        collectionView: self.collectionView,
        cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainHomePromiseCell.identifier,
                for: indexPath) as?  MainHomePromiseCell else { return UICollectionViewCell() }
            cell.setData(itemIdentifier)
            return cell
        })
    
    lazy var pageLabel: PaddingLabel = {
        let label = PaddingLabel(padding: .init(top: 2, left: 14, bottom: 2, right: 14))
        label.backgroundColor = .wwwColor(.WWWWhite)
        label.clipsToBounds = true
        label.layer.cornerRadius = 26/2
        label.layer.borderColor = UIColor.wwwColor(.Gray200).cgColor
        label.layer.borderWidth = 1
        label.customAttributedString(
            text: "\(Int(currentIndex)+1)/5",
            highlightText: "\(Int(currentIndex)+1)",
            textFont: .www(size: 14)!,
            highlightTextFont: .www(size: 14)!,
            textColor: .wwwColor(.Gray450),
            highlightTextColor: .wwwColor(.WWWGreen)
        )
        return label
    }()
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(.floating_add), for: .normal)
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
        setAction()
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
            $0.width.equalTo(60)
            $0.height.equalTo(26)
        }
        
        self.view.addSubview(settingButton)
        settingButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(26)
        }
        
        self.view.addSubview(promiseButtonTabStackView)
        promiseButtonTabStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.leading.equalToSuperview().inset(20)
        }
        
        promiseButtonTabStackView.addArrangedSubviews(proceedingPromiseButton, endedPromiseButton)
        
        self.view.addSubview(promiseContentView)
        promiseContentView.snp.makeConstraints {
            $0.top.equalTo(promiseButtonTabStackView.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        promiseContentView.addSubview(emptyPromiseView)
        emptyPromiseView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(90)
            $0.centerX.equalToSuperview()
        }
        
        promiseContentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        collectionView.delegate = self
        
        promiseContentView.addSubview(pageLabel)
        pageLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
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
    
    private func applyData(items: [MeetingMain], section: Section) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MeetingMain>()
        snapshot.appendSections([section])
        snapshot.appendItems(items)
        self.dataSource.apply(snapshot, animatingDifferences: true)
        self.collectionView.setContentOffset(.init(x: -collectionView.contentInset.left, y: .zero), animated: true)
    }
    
    private func setAction() {
        settingButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let vm = SettingViewModel()
                self?.navigationController?.pushViewController(SettingViewController(viewModel: vm), animated: true)
            }).disposed(by: bag)
        
        proceedingPromiseButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                // 진행중인 약속
                self?.proceedingPromiseButton.isEnabled = false
                self?.endedPromiseButton.isEnabled = true
                let proceeding = self?.fetchedMainHomeMeeting.proceedingMeetings ?? []
                self?.applyData(items: proceeding, section: .proceeding)
                
            }).disposed(by: bag)
        
        endedPromiseButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                // 종료된 약속
                self?.proceedingPromiseButton.isEnabled = true
                self?.endedPromiseButton.isEnabled = false
                
                let ended = self?.fetchedMainHomeMeeting.endedMeetings ?? []
                self?.applyData(items: ended, section: .ended)
            }).disposed(by: bag)
        
        floatingButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dimView.isHidden = false
            }).disposed(by: bag)
        
        dimView.floatingButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dimView.isHidden = true
            }).disposed(by: bag)
        
        dimView.addPromiseButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let vm = RoomNameViewModel(joinAdminUseCase: JoinHostUseCase())
                self?.navigationController?.pushViewController(RoomNameViewController(viewModel: vm), animated: true)
            }).disposed(by: bag)
        
        dimView.enterWithCodeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let vm = RoomCodeViewModel(joinGuestUseCase: JoinGuestUseCase())
                self?.navigationController?.pushViewController(RoomCodeController(viewModel: vm), animated: true)
            }).disposed(by: bag)
    }
    
    private func bindRx() {
        let input = MainHomeViewModel.Input(viewDidLoad: Observable.just(()).asObservable())
        
        let output = viewModel?.transform(input: input, disposeBag: bag)
        
        output?.mainHomeMeeting.subscribe(onSuccess: { [weak self] in
            print("mainHomeMeeting",$0)
            self?.fetchedMainHomeMeeting = $0
            self?.applyData(items: $0.proceedingMeetings, section: .proceeding)
        }).disposed(by: bag)
        
    }
    
}

extension MainHomeViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if isOneStepPaging {
            if currentIndex > roundedIndex {
                currentIndex -= 1
                roundedIndex = currentIndex
            } else if currentIndex < roundedIndex {
                currentIndex += 1
                roundedIndex = currentIndex
            }
        }
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    
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

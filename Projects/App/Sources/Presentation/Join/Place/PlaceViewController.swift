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

typealias PlaceDataSource = UICollectionViewDiffableDataSource<Section, WrappedPlace>
typealias PlaceSnapshot = NSDiffableDataSourceSnapshot<Section, WrappedPlace>


enum Section {
    case place
}

final class PlaceViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel: PlaceViewModel
    private let userMode: UserType
    private var fetchedPlace: [WrappedPlace] = []
    
    private lazy var dataSource = makeDataSource()
    
    private let progressView = ProgressView(current: 6, total: 6)
    
    private let titleView = BasicTitleView(title: "원하는 장소를 입력해 주세요.",
                                           subTitle: "*필수 항목이 아니에요.")
    
    private lazy var textFieldView = PlustTextFieldView(placeholder: "장소 입력")
    
    lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 장소 후보"
        label.textColor = UIColor.wwwColor(.WWWBlack)
        label.numberOfLines = 1
        label.font = UIFont.www.body1
        return label
    }()
    
    private lazy var placeNumberLabel: UILabel = {
        let label = UILabel()
//        label.text = "0"
        label.textColor = UIColor.wwwColor(.WWWGreen)
        label.numberOfLines = 1
        label.font = UIFont.www.body1
        return label
    }()
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("스킵할래요", for: .normal)
        $0.setButtonState(true)
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
    
    // Navigation Items
    private let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(.chevron_left), style: .plain, target: UserNameViewController.self, action: #selector(backButtonDidTap))
    
    private let progressLabel = UILabel()
    
    
    // MARK: - LifeCycle
    init(viewModel: PlaceViewModel, userMode: UserType) {
        self.viewModel = viewModel
        self.userMode = userMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFieldView.textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.bindViewModel()
        self.setUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

// MARK: - Methods
extension PlaceViewController {
    
    private func setUI() {
        self.view.backgroundColor = .wwwColor(.WWWWhite)
        
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
            $0.height.equalTo(110)
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
    private func setNavigationBar(title: String = "", step: String = "") {
        backButton.tintColor = .black
        progressLabel.text = step
        progressLabel.font = UIFont.www.body3
        let progressItem: UIBarButtonItem = UIBarButtonItem(customView: progressLabel)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = progressItem
        navigationItem.title = title
    }
    
    
    @objc func backButtonDidTap() {}
}

// MARK: - Binding

private extension PlaceViewController {
    func bindViewModel() {
        let input = PlaceViewModel.Input(
            viewDidLoad:
                Observable.just(()).asObservable(),
            placeTextFieldDidEdit:
                textFieldView.textField.rx.text.orEmpty.asObservable(),
            plusButtonDidTap:
                self.textFieldView.plusButton.rx.tap.asObservable(),
            placeCellDidTap:
                self.chipCollectionView.rx.itemSelected.map{$0.row},
            nextButtonDidTap:
                self.nextButton.rx.tap.asObservable(),
            backButtonDidTap:
                self.navigationItem.leftBarButtonItem!.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(input: input, disposeBag: self.disposeBag)
        self.bindCollectionView(output: output)
        self.bindPager(output: output)
        
        output.flushTextField
            .asDriver(onErrorJustReturn: Void())
            .drive(onNext: { [weak self]  in
                self?.textFieldView.textField.text = ""
            })
            .disposed(by: disposeBag)
        
        output.plusButtonMakeEnable
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isEnabled in
                if isEnabled {
                    self?.textFieldView.enablePlusButton()
                } else {
                    self?.textFieldView.disablePlusButton()
                }
            })
            .disposed(by: disposeBag)
        
        output.naviTitleText
            .asDriver()
            .drive(onNext: { [weak self] title in
                switch self?.userMode {
                case .host:
                    print(title)
                    self?.progressView.setProgress(current: 6, total: 6)
                    self?.setNavigationBar(title: title, step: "6/6")
                case .guest:
                    self?.progressView.setProgress(current: 4, total: 4)
                    self?.setNavigationBar(title: title, step: "4/4")
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        output.nextButtonMakeEnable
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isEnabled in
                self?.nextButton.setTitle(isEnabled ? "다음" : "스킵할래요", for: .normal)
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindCollectionView(output: PlaceViewModel.Output?){
        output?.initPlaces
            .asDriver()
            .drive { [weak self] places in
                self?.applySnapshot(places: places)
                self?.placeNumberLabel.text = String(places.count)
            }
            .disposed(by: disposeBag)
        
        output?.updatePlaces
            .asDriver()
            .drive { [weak self] places in
                self?.updateSnapshot(places: places)
                let placelist = self?.dataSource.snapshot().itemIdentifiers(inSection: .place)
                self?.placeNumberLabel.text = String(placelist?.count ?? 0)
            }
            .disposed(by: disposeBag)
    }
    
    func bindPager(output: PlaceViewModel.Output?){
        output?.navigatePage
            .asDriver(onErrorJustReturn: .error)
            .drive(onNext: { [weak self] page in
                switch page {
                case .back:
                    self?.navigationController?.popViewController(animated: true)
                case .completion:
                    self?.view.endEditing(true)
                    self?.textFieldView.textField.resignFirstResponder()
                    let viewmodel = CompletionViewModel(usecase: self!.viewModel.getHostUsecase())
                    self?.navigationController?.pushViewController(CompletionViewcController(viewModel: viewmodel), animated: true)
                case .roomMain:
//                    self?.view.endEditing(true)
//                    self?.textFieldView.textField.resignFirstResponder()
//                    self?.navigationController?.popToRootViewController(animated: true)
                    // TODO: - 홈메인으로 이동
                    print("🔥 완료되었습니다!")
                case .error: break
                }
            })
            .disposed(by: disposeBag)
    }
    
}


// MARK: - Privates

private extension PlaceViewController {
    
    func applySnapshot(places: [WrappedPlace]) {
      fetchedPlace = places
      var snapshot = PlaceSnapshot()
      snapshot.appendSections([.place])
      snapshot.appendItems(places, toSection: .place)
      dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func makeDataSource() -> PlaceDataSource {
      let dataSource = PlaceDataSource(
        collectionView: chipCollectionView,
        cellProvider: { (collectionView, indexPath, place: WrappedPlace) ->
          UICollectionViewCell? in
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
      })
      return dataSource
    }
 
     func updateSnapshot(places: [WrappedPlace]) {
        var snapshot = dataSource.snapshot()
        let previousItems = snapshot.itemIdentifiers(inSection: .place)
        snapshot.deleteItems(previousItems)
        snapshot.appendItems(places, toSection: .place)
        snapshot.appendItems(fetchedPlace, toSection: .place)
        dataSource.apply(snapshot)
    }
    
}


// MARK: - Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct PlaceViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        let viewModel = PlaceViewModel(guest: JoinGuestUseCase())
//        PlaceViewController(viewModel: viewModel, userMode: .guest).toPreview()
//    }
//}
//#endif

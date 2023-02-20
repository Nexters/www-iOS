//
//  TimeViewController.swift
//  AppTests
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

enum TimeSection {
    case meetingTime
}

final class TimeViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    //    var viewModel: TimeViewModel?
    
    private lazy var dataSource = configureDataSource()
    
    private let progressView = ProgressView(current: 3, total: 4)
    
    private let titleView = BasicTitleView(title: "가능한 시간대를 선택해주세요.",
                                           subTitle: "2월 21일 (화) - 3월 3일 (금)")
    
    private let dateView = DateStackView()
    
    private let line: UIView = {
        $0.backgroundColor = .wwwColor(.Gray150)
        return $0
    }(UIView())
    
    private let timeView = TimeStackView()
    
    private let pickerView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8.horizontallyAdjusted
        layout.minimumInteritemSpacing = 8.verticallyAdjusted
        layout.itemSize = CGSize(width: 59.horizontallyAdjusted,
                                 height: 64.verticallyAdjusted)
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.register(TimeCheckCell.self, forCellWithReuseIdentifier: "TimeCheckCell")
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.isPagingEnabled = true
        let xPosition = 266.horizontallyAdjusted
        collectionview.frame = CGRect(x: xPosition,
                                      y: 0,
                                      width: 266.horizontallyAdjusted,
                                      height: 286.verticallyAdjusted)
        return collectionview
    }()
    
    private let pageControl: UIPageControl = {
        $0.currentPage = 0
        $0.isEnabled = false
        $0.currentPageIndicatorTintColor = .wwwColor(.WWWGreen)
        $0.pageIndicatorTintColor = .wwwColor(.Gray200)
        $0.isUserInteractionEnabled = true
        return $0
    }(UIPageControl())
    
    private lazy var chipCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(DeleteChipCell.self, forCellWithReuseIdentifier: DeleteChipCell.identifier)
        collectionView.layer.cornerRadius = 10.verticallyAdjusted
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.wwwColor(.Gray100).cgColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset.top = ((56.verticallyAdjusted - 34)/2)
        collectionView.contentInset.left = 14
        collectionView.contentInset.right = 14
        return collectionView
    }()
    
    private lazy var nextButton: LargeButton = {
        $0.setTitle("다음", for: .normal)
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
        setUI()
        setPicker(with: 2)
        setNavigationBar()
        
        let sample = ["25 (토) 낮","26 (일) 저녁", "27 (월) 저녁"]
        applySnapshot(times: sample)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Function

extension TimeViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        //        pickerView.delegate = self
        
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
        
        self.view.addSubview(dateView)
        dateView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(44.verticallyAdjusted)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(line)
        line.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(dateView.snp.bottom)
        }
        
        self.view.addSubview(timeView)
        timeView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(16.verticallyAdjusted)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(59.horizontallyAdjusted)
            $0.height.equalTo(286.verticallyAdjusted)
        }
        
        self.view.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(16.verticallyAdjusted)
            $0.leading.equalTo(timeView.snp.trailing).offset(10.horizontallyAdjusted)
            $0.width.equalTo(266.horizontallyAdjusted)
            $0.height.equalTo(286.verticallyAdjusted)
        }
        
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.top.equalTo(timeView.snp.bottom).offset(20.verticallyAdjusted)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        self.view.addSubview(chipCollectionView)
        chipCollectionView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(36.verticallyAdjusted)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56.verticallyAdjusted)
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
        progressLabel.text = "3/4"
        progressLabel.font = UIFont.www.body3
        let progressItem: UIBarButtonItem = UIBarButtonItem(customView: progressLabel)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = progressItem
        navigationItem.title = title
    }
    
    @objc func backButtonDidTap() {}
    
}

// MARK: - Binding
private extension TimeViewController {
    
}
 
// MARK: - ScrollView
extension TimeViewController {
    private func setPicker(with pages: Int = 3) {
        pickerView.delegate = self
        pickerView.dataSource = self
        pageControl.numberOfPages = pages
    }
}
    
// MARK: - ChipCollectionView
private extension TimeViewController {
    
    func applySnapshot(times: [String]) {
      var snapshot = NSDiffableDataSourceSnapshot<TimeSection, String>()
      snapshot.appendSections([.meetingTime])
      snapshot.appendItems(times, toSection: .meetingTime)
      dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureDataSource() ->  UICollectionViewDiffableDataSource<TimeSection, String> {
      let dataSource =  UICollectionViewDiffableDataSource<TimeSection, String>(
        collectionView: chipCollectionView,
        cellProvider: { (collectionView, indexPath, selectedTime: String) ->
          UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeleteChipCell.identifier, for: indexPath)
                    as? DeleteChipCell else {
                return UICollectionViewCell()
            }
            cell.configure(selectedTime)
            return cell
      })
      return dataSource
    }
 
     func updateSnapshot(times: [String]) {
        var snapshot = dataSource.snapshot()
        let previousItems = snapshot.itemIdentifiers(inSection: .meetingTime)
        snapshot.deleteItems(previousItems)
        snapshot.appendItems(times, toSection: .meetingTime)
        snapshot.appendItems(times, toSection: .meetingTime)
        dataSource.apply(snapshot)
    }
    
}

// MARK: - PickerView

extension TimeViewController: UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 32
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCheckCell", for: indexPath)
                as? TimeCheckCell else {
            return UICollectionViewCell()
            
        }
//        cell.configure(with: categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimeCheckCell
        cell.onSelected()
        // 아이템 담기, 빼기
//        print("😉",indexPath.row)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let pageOffset = ScrollPageController().pageOffset(
            for: scrollView.contentOffset.x,
            velocity: velocity.x,
            in: pageOffsets(in: scrollView)
        ) {
            targetContentOffset.pointee.x = pageOffset
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let pageOffset = ScrollPageController().pageOffset(
            for: scrollView.contentOffset.x,
            velocity: velocity.x,
            in: pageOffsets(in: scrollView)
        ) {
            targetContentOffset.pointee.x = pageOffset
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    private func pageOffsets(in scrollView: UIScrollView) -> [CGFloat] {
        return scrollView.subviews
                         .compactMap { $0 as? UIImageView }
                         .map { $0.frame.minX - scrollView.adjustedContentInset.left }
    }
    
    
    
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TimeViewController_Preview: PreviewProvider {
    static var previews: some View {
        TimeViewController().toPreview()
    }
}
#endif

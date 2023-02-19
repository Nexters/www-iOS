////
////  TimeGridCollectionView.swift
////  App
////
////  Created by Chanhee Jeong on 2023/02/19.
////  Copyright © 2023 com.promise8. All rights reserved.
////
//
//import UIKit
//
//final class TimeGridCollectionView: UICollectionView {
//
//    private lazy var categoryCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollecionViewLayout())
//
//}
//extension TimeGridCollectionView {
//
//    private func configureUI() {
//        
//        self.backgroundColor = .green
//        categoryCollectionView.register(TimeCheckCell.self, forCellWithReuseIdentifier: "TimeCheckCell")
//        categoryCollectionView.isScrollEnabled = false
//        categoryCollectionView.delegate = self
//        categoryCollectionView.dataSource = self
//        categoryCollectionView.backgroundColor = .clear
//    }
//}
//
//
//extension TimeGridCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    private func createCollecionViewLayout() -> UICollectionViewCompositionalLayout {
//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
//        group.interItemSpacing = .fixed(10)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = CGFloat(0)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 16
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCheckCell", for: indexPath)
//                as? TimeCheckCell else {
//            return UICollectionViewCell()
//
//        }
////        cell.configure(with: categories[indexPath.row])
////        cell.configure(with: "아이콘")
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("😉",indexPath.row)
//    }
//
//}

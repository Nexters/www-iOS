//
//  OnBoardingPageViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/01.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class OnBoardingPageViewController: UIPageViewController {
    
    // MARK: - Properties
    private var pages = [UIViewController]()
    private let initialPage = 0
    private var currentIdx = 0
    
    private lazy var nextButton: UIFullWidthButton = { [weak self] in
        $0.title = "시작하기"
        $0.action = UIAction { _ in
            self?.nextButtonDidTap()
        }
        return $0
    }(UIFullWidthButton())

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
}

// MARK: - UI Functions

extension OnBoardingPageViewController {

    private func setUI() {
        dataSource = self
        delegate = self
        
        view.backgroundColor = .white
        
        let page1 = OBImageViewController(imageName: "on1")
        let page2 = OBImageViewController(imageName: "on2")
        let page3 = OBImageViewController(imageName: "on3")
        let page4 = OBImageViewController(imageName: "on4")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        removeSwipeGesture()
    }
    
    private func setLayout() {
        view.addSubviews(nextButton)

        nextButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: - DataSources

extension OnBoardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
    
}

// MARK: - Delegates

extension OnBoardingPageViewController: UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        currentIdx = currentIndex
        updateButtonIfNeeded()
    }
    
    
}

// MARK: - Actions

extension OnBoardingPageViewController {
    
    @objc private func backButtonDidTap(_ sender: UIButton) {
        if currentIdx != 0 {
            currentIdx -= 1
            goToPreviousPage()
            updateButtonIfNeeded()
        }
    }
    
    private func nextButtonDidTap() {
        if currentIdx == pages.count - 1 {
            goToInitialViewController()
        } else {
            currentIdx += 1
            goToNextPage()
            updateButtonIfNeeded()
        }
    }
    
    private func goToInitialViewController() {
        UserDefaultKeyCase().setOnBoarding(true)
        let mainHomeVC = MainHomeViewController(viewModel: MainHomeViewModel(mainHomeUseCase: .init(meetingRepository: MainHomeDAO.init(network: MeetingAPIManager.provider))))
        self.view.window?.rootViewController = UINavigationController(rootViewController: mainHomeVC)
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    private func updateButtonIfNeeded() {
        switch currentIdx {
        case 0:
            nextButton.setTitle("시작하기", for: .normal)
        case 1:
            nextButton.setTitle("다음", for: .normal)
        case 2:
            nextButton.setTitle("다음", for: .normal)
        case 3:
            nextButton.setTitle("다음", for: .normal)
        default:
            return
        }
    }
    
    private func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    private func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .reverse, animated: animated, completion: completion)
    }
    
    private func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
}

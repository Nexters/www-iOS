//
//  ViewController.swift
//  www
//
//  Created by Chanhee Jeong on 2023/01/31.
//

import UIKit
import SnapKit

class SampleViewController: UIViewController {
    
    private lazy var testButton: LargeButton = {
        $0.setTitle("테스트버튼", for: .normal)
        $0.addTarget(self, action: #selector(testButtonDidTap), for: .touchUpInside)
        return $0
    }(LargeButton(state: true))


    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI() {
        self.view.backgroundColor = .white
        view.addSubviews(testButton)
        testButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc func testButtonDidTap() {
        let viewModel = RoomCodeViewModel(joinGuestUseCase: JoinGuestUseCase())
        self.navigationController?.pushViewController(RoomCodeController(viewModel: viewModel), animated: true)
    }
}


//
//  ViewController.swift
//  www
//
//  Created by Chanhee Jeong on 2023/01/31.
//

import UIKit
import SnapKit
import RxSwift

class SampleViewController: UIViewController {
    
    private lazy var testButton: LargeButton = {
        $0.setTitle("테스트버튼", for: .normal)
        $0.addTarget(self, action: #selector(testButtonDidTap), for: .touchUpInside)
        return $0
    }(LargeButton(state: true))

    private var viewModel: SampleViewModel?
    
    private var bag = DisposeBag()
    
    init(viewModel: SampleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
 
        let hostVM = PlaceViewModel(host: JoinHostUseCase())
//        let guestVM = PlaceViewModel(guest: JoinGuestUseCase())
        
        self.navigationController?.pushViewController(PlaceViewController(viewModel: hostVM), animated: true)
    
    }
    
    private func bindRx() {
        let output = viewModel?.transform(input: SampleViewModel.Input(viewDidLoad: Single<Void>.just(()) ), disposeBag: DisposeBag())
        
        // 참가자 플로우
//        let viewModel = RoomCodeViewModel(joinGuestUseCase: JoinGuestUseCase())
//        self.navigationController?.pushViewController(RoomCodeController(viewModel: viewModel), animated: true)
        
    }
}


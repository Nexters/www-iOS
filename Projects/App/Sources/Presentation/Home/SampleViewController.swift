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

//    private var viewModel: SampleViewModel?
    
    private var bag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
//        bindRx()
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
 
//        let hostVM = PlaceViewModel(host: JoinHostUseCase())
//        let guestVM = PlaceViewModel(guest: JoinGuestUseCase())
        
        self.navigationController?.pushViewController(PlaceVoteViewController(viewmodel: PlaceVoteViewModel(usecase: PlaceVoteUseCase(repository: PlaceVoteDAO.init(network: VoteAPI.provider)), roomId: 193, status: .voting)), animated: true)
    
    }
    
//    private func bindRx() {
//        let output = viewModel?.transform(input: SampleViewModel.Input(viewDidLoad: Single<Void>.just(()) ), disposeBag: DisposeBag())
        
        // 참가자 플로우
//        let viewModel = RoomCodeViewModel(joinGuestUseCase: JoinGuestUseCase())
//        self.navigationController?.pushViewController(RoomCodeController(viewModel: viewModel), animated: true)
        
//        output?.loginResult.subscribe {
//            print("loginResult is", $0)
//            UserDefaultKeyCase().setUserToken($0.result)
//
//        }.disposed(by: bag)
//    }
}


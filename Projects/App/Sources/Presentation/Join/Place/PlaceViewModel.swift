//
//  PlaceViewModel.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/16.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

enum PlacePager {
    case error
    case back
    case completion
    case roomMain
}

final class PlaceViewModel: BaseViewModel {
    
    private let hostUsecase: JoinHostUseCase?
    private let guestUsecase: JoinGuestUseCase?
    
    private var places: [WrappedPlace] = []
    private var enteredPlaces = BehaviorRelay<[WrappedPlace]>(value: [])
    private var placeName = BehaviorSubject<String>(value: "")
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let placeTextFieldDidEdit: Observable<String>
        let plusButtonDidTap: Observable<Void>
        let placeCellDidTap: Observable<Int>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var naviTitleText = BehaviorRelay<String>(value: "")
        var flushTextField = PublishRelay<Void>()
        var plusButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var initPlaces = BehaviorRelay<[WrappedPlace]>(value: [])
        var updatePlaces = BehaviorRelay<[WrappedPlace]>(value: [])
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<PlacePager>()
    }
    
    init(host: JoinHostUseCase? = nil, guest: JoinGuestUseCase? = nil) {
        self.hostUsecase = host
        self.guestUsecase = guest
    }
    
    // MARK: - Transform
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        if guestUsecase != nil {  // Guest
            self.handleInputGuest(input, disposeBag: disposeBag)
            return makeOutputGuest(with: input, disposeBag: disposeBag)
        } else {  // Host
            self.handleInputHost(input, disposeBag: disposeBag)
            return makeOutputHost(with: input, disposeBag: disposeBag)
        }
    }
    
    func getHostUsecase() -> JoinHostUseCase {
        return self.hostUsecase!
    }
}

// MARK: - HOST
extension PlaceViewModel {
    
    private func handleInputHost(_ input: Input, disposeBag: DisposeBag) {
        input.placeTextFieldDidEdit
            .bind(to: self.placeName)
            .disposed(by: disposeBag)
        
        input.placeCellDidTap
            .subscribe(onNext: { [weak self] in
                var placelist: [WrappedPlace] = []
                self?.enteredPlaces
                    .asDriver()
                    .drive { places in
                        placelist += places
                    }
                    .disposed(by: disposeBag)
                if placelist.count > 0 {
                    placelist.remove(at: $0)
                    self?.enteredPlaces.accept(placelist)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func makeOutputHost(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.places = self?.hostUsecase!.getServerPlaceList() ?? []
                output.initPlaces.accept(self?.places ?? [])
                output.naviTitleText.accept(try! (self?.hostUsecase!.roomName)!.value())
            })
            .disposed(by: disposeBag)
        
        input.plusButtonDidTap
            .subscribe(onNext: { [weak self] in
                guard let placename = try? self?.placeName.value() else { return }
                if placename != "" {
                    var placelist: [WrappedPlace] = []
                    self?.enteredPlaces
                        .asDriver()
                        .drive { places in
                            placelist += places
                        }
                        .disposed(by: disposeBag)
                    let place = WrappedPlace(isFromLocal: true, place: Place(title: placename))
                    let serverPlace = WrappedPlace(isFromLocal: false, place: Place(title: placename))
                    
                    guard placelist.contains(place) != true, self?.places.contains(serverPlace) != true else { return }
                    placelist.insert(contentsOf: [place], at: 0)
                    self?.enteredPlaces.accept(placelist)
                }
                output.flushTextField.accept(())
                output.plusButtonMakeEnable.accept(false)
            })
            .disposed(by: disposeBag)
        
        self.placeName
            .subscribe(onNext: { [weak self] p in
                guard let place = try? self?.placeName.value() else { return }
                output.plusButtonMakeEnable.accept(place != "")
            })
            .disposed(by: disposeBag)
        
        self.enteredPlaces
            .subscribe(onNext: { enteredPlaces in
                output.updatePlaces.accept(enteredPlaces)
                output.nextButtonMakeEnable.accept(enteredPlaces.count > 0)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.back)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .subscribe(onNext: { [weak self] in
                var placelist: [WrappedPlace] = []
                self?.enteredPlaces
                    .asDriver()
                    .drive { places in
                        placelist += places
                    }
                    .disposed(by: disposeBag)
                self?.hostUsecase?.addMyPlaces(placelist)
                output.navigatePage.accept(.completion)
            })
            .disposed(by: disposeBag)
        
        return output
        
    }
    
}

// MARK: - Guest
extension PlaceViewModel {
    
    private func handleInputGuest(_ input: Input, disposeBag: DisposeBag) {
        input.placeTextFieldDidEdit
            .bind(to: self.placeName)
            .disposed(by: disposeBag)
        
        input.placeCellDidTap
            .subscribe(onNext: { [weak self] in
                var placelist: [WrappedPlace] = []
                self?.enteredPlaces
                    .asDriver()
                    .drive { places in
                        placelist += places
                    }
                    .disposed(by: disposeBag)
                if placelist.count > 0 {
                    placelist.remove(at: $0)
                    self?.enteredPlaces.accept(placelist)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func makeOutputGuest(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.places = self?.guestUsecase!.getServerPlaceList() ?? []
                output.naviTitleText.accept((self?.guestUsecase!.roomName)!)
                output.initPlaces.accept(self?.places ?? [])
            })
            .disposed(by: disposeBag)
        
        input.plusButtonDidTap
            .subscribe(onNext: { [weak self] in
                guard let place = try? self?.placeName.value() else { return }
                if place != "" {
                    var placelist: [WrappedPlace] = []
                    self?.enteredPlaces
                        .asDriver()
                        .drive { places in
                            placelist += places
                        }
                        .disposed(by: disposeBag)
                    let place = WrappedPlace(isFromLocal: true, place: Place(title: place))
                    guard placelist.contains(place) != true, self?.places.contains(place) != true else { return }
                    placelist.insert(contentsOf: [place], at: 0)
                    self?.enteredPlaces.accept(placelist)
                }
                output.flushTextField.accept(())
                output.plusButtonMakeEnable.accept(false)
            })
            .disposed(by: disposeBag)
        
        self.placeName
            .subscribe(onNext: { [weak self] p in
                guard let place = try? self?.placeName.value() else { return }
                output.plusButtonMakeEnable.accept(place != "")
            })
            .disposed(by: disposeBag)
        
        self.enteredPlaces
            .subscribe(onNext: { enteredPlaces in
                output.updatePlaces.accept(enteredPlaces)
                output.nextButtonMakeEnable.accept(enteredPlaces.count > 0)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.back)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .subscribe(onNext: { [weak self] in
                var placelist: [WrappedPlace] = []
                self?.enteredPlaces
                    .asDriver()
                    .drive { places in
                        placelist += places
                    }
                    .disposed(by: disposeBag)
                self?.hostUsecase?.addMyPlaces(placelist)
                output.navigatePage.accept(.roomMain)
            })
            .disposed(by: disposeBag)
        
        return output
        
    }
    
}

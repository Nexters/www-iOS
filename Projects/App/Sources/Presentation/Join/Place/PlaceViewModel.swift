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
    
    let usecase: JoinHostUseCase
    
    private var places: [WrappedPlace] = []
    private var enteredPlaces = PublishRelay<[WrappedPlace]>()
    private var placeName = ""
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let placeTextFieldDidEdit: Observable<String>
        let plusButtonDidTap: Observable<Void>
        let placeCellDidTap: Observable<Int>
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var flushTextField = PublishRelay<Void>()
        var initPlaces = BehaviorRelay<[WrappedPlace]>(value: [])
        var updatePlaces = BehaviorRelay<[WrappedPlace]>(value: [])
        var nextButtonMakeEnable = BehaviorRelay<Bool>(value: false)
        var navigatePage = PublishRelay<PlacePager>()
    }
    
    init(usecase: JoinHostUseCase) {
        self.usecase = usecase
    }

    // MARK: - Transform
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.handleInput(input, disposeBag: disposeBag)
        return makeOutput(with:  input, disposeBag: disposeBag)
    }
    
    private func handleInput(_ input: Input, disposeBag: DisposeBag) {
        
        input.placeTextFieldDidEdit
            .map{ $0 }
            .subscribe(onNext: {
                self.placeName = $0
            })
            .disposed(by: disposeBag)
        
        input.placeCellDidTap
            .subscribe(onNext: { [weak self] in
                
                guard let places = try? self?.enteredPlaces.values else { return }
                print("✅\($0)",places)
                
                
//                self?.enteredPlaces.accept()
            })
        
            .disposed(by: disposeBag)
    }
    
    private func makeOutput(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.places = self?.usecase.getPlaceList() ?? []
                output.initPlaces.accept(self?.places ?? [])
            })
            .disposed(by: disposeBag)
        
        input.plusButtonDidTap
            .subscribe(onNext: { [weak self] in
                if self?.placeName != "" {
                    let place = WrappedPlace(isFromLocal: true, place: Place(title: self!.placeName))
                    self?.enteredPlaces.accept([place])
                }
                output.flushTextField.accept(())
            })
            .disposed(by: disposeBag)
        
        self.enteredPlaces
            .subscribe(onNext: { enteredPlaces in
                output.updatePlaces.accept(enteredPlaces)
                
                output.nextButtonMakeEnable.accept(enteredPlaces.count > 0 ? true : false)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.back)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .subscribe(onNext: {
                output.navigatePage.accept(.completion)
            })
            .disposed(by: disposeBag)
        
        return output
        
    }
    
}

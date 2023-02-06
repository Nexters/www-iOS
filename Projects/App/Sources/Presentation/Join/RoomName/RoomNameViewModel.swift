//
//  RoomNameViewModel.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/07.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxCocoa
import RxSwift


final class RoomNameViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }

    var disposeBag = DisposeBag()
    
    init() {}

    func transform(input: Input) -> Output {
        return Output.init() // 샘플임...!
    }
    
}

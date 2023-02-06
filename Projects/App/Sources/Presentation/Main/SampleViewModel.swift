//
//  SampleViewModel.swift
//  www
//
//  Created by Chanhee Jeong on 2023/02/01.
//

import RxCocoa
import RxSwift


final class SampleViewModel: BaseViewModel {
    
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

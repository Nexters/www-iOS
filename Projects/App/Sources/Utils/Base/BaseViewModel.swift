//
//  ViewModelType.swift
//  www
//
//  Created by Chanhee Jeong on 2023/02/01.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

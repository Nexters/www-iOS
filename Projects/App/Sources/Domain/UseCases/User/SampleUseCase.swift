////
////  SampleUseCase.swift
////  www
////
////  Created by Chanhee Jeong on 2023/01/31.
////
//
//import RxSwift
//
//protocol SampleUseCaseProtocol {
//    func excute() -> Single<Int>
//}
//
//final class SampleUseCase: SampleUseCaseProtocol {
//    
//    // MARK: - Properties
//    private let sampleRepository: SampleRepository
//    
//    // MARK: - Methods
//    init(sampleRepository: SampleRepository) {
//        self.sampleRepository = sampleRepository
//    }
//    
//    func excute() -> Single<Int> {
//        return self.sampleRepository.fetchSampleList()
//    }
//    
//}
//
//// MARK: - Privates
//private extension SampleUseCaseProtocol {
//    
//}

//
//  RxMoya.swift
//  www
//
//  Created by kokojong on 2023/02/05.
//

import Moya
import RxSwift

public class RxMoyaProvider<Target>: MoyaProvider<Target> where Target: TargetType {
  public func request(_ token: Target) -> Observable<Response> {
    return Observable.create { [weak self] observer in
      let cancellableToken = self?.request(token) { result in
        switch result {
        case let .success(response):
          observer.onNext(response)
          observer.onCompleted()
          break
        case let .failure(error):
          observer.onError(error)
        }
      }
      return Disposables.create {
        cancellableToken?.cancel()
      }
    }.observe(on: SerialDispatchQueueScheduler(qos: .background))
  }
}

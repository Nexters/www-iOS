//
//  RxMoya.swift
//  www
//
//  Created by kokojong on 2023/02/05.
//

import Moya
import RxSwift

public class RxMoyaProvider<Target>: MoyaProvider<Target> where Target: TargetType {
  public func request(_ api: Target) -> Observable<Response> {
    return Observable.create { [weak self] observer in
      let cancellableToken = self?.request(api) { result in
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

class LoggerPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        guard let request = request.request else { return }
        
        var log = "-----> \(request.httpMethod ?? "")\n"
        log.append(String(describing: request.url?.absoluteString ?? "") + "\n")
        log.append("API: \(target)\n")
        if let body = request.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("\(bodyString)\n")
        }
        log.append("-----> END\n")
        print(log)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSuccess(response, target: target)
        case let .failure(error):
            onFailure(error, target: target)
        }
    }
    
    private func onSuccess(_ response: Response, target: TargetType) {
        var log = "🙆‍♂️ ----------\(response.statusCode)----------\n"
        log.append("API: \(target)\n")
        response.response?.allHeaderFields.forEach {
          log.append("\($0): \($1)\n")
        }
        if let responseStr = String(bytes: response.data, encoding: String.Encoding.utf8) {
          log.append("\(responseStr)\n")
        }
        log.append("\n🙆‍♂️----------End----------\n")
        print(log)
    }
    
    private func onFailure(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSuccess(response, target: target)
        }
        
        var log = "🙅‍♂️ ----------\(error.errorCode) \(target)----------\n"
        log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error)\n")")
        log.append("\n🙅‍♂️----------End----------\n")
        print(log)
    }
}

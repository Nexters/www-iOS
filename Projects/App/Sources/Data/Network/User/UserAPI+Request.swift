//
//  UserAPI+Request.swift
//  www
//
//  Created by kokojong on 2023/02/05.
//

import Foundation
import Moya

extension UserAPI {
    struct Plugins {
        var plugins: [PluginType]
        
        init(plugins: [PluginType] = []) {
            self.plugins = plugins
        }
        
        func callAsFunction() -> [PluginType] { self.plugins }
    }
    
    static var provider: RxMoyaProvider<UserAPI> {
        let plugins = Plugins(plugins: [LoggerPlugin()])
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.urlCredentialStorage = nil
        let session = Session(configuration: configuration)
        
        return RxMoyaProvider<UserAPI>(
            endpointClosure: { target in
                MoyaProvider.defaultEndpointMapping(for: target)
            },
            session: session,
            plugins: plugins()
        )
    }
}

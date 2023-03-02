//
//  VoteAPI+Request.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/02.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import Moya

extension VoteAPI {
    struct Plugins {
        var plugins: [PluginType]
        
        init(plugins: [PluginType] = []) {
            self.plugins = plugins
        }
        
        func callAsFunction() -> [PluginType] { self.plugins }
    }
    
    static var provider: RxMoyaProvider<VoteAPI> {
        let plugins = Plugins(plugins: [LoggerPlugin()])
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.urlCredentialStorage = nil
        let session = Session(configuration: configuration)
        
        return RxMoyaProvider<VoteAPI>(
            endpointClosure: { target in
                MoyaProvider.defaultEndpointMapping(for: target)
            },
            session: session,
            plugins: plugins()
        )
    }
}

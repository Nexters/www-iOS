//
//  MeetingAPI+Request.swift
//  App
//
//  Created by kokojong on 2023/02/22.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation
import Moya

extension MeetingAPI {
    struct Plugins {
        var plugins: [PluginType]
        
        init(plugins: [PluginType] = []) {
            self.plugins = plugins
        }
        
        func callAsFunction() -> [PluginType] { self.plugins }
    }
    
    static var provider: RxMoyaProvider<MeetingAPI> {
        let plugins = Plugins(plugins: [LoggerPlugin()])
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.urlCredentialStorage = nil
        let session = Session(configuration: configuration)
        
        return RxMoyaProvider<MeetingAPI>(
            endpointClosure: { target in
                MoyaProvider.defaultEndpointMapping(for: target)
            },
            session: session,
            plugins: plugins()
        )
    }
}

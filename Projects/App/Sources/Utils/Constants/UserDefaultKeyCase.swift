//
//  UserDefaultKeyCase.swift
//  App
//
//  Created by kokojong on 2023/02/14.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct UserDefaultKeyCase {
    private let userToken = "userToken"
    
    func getUserToken() -> String {
        UserDefaults.standard.string(forKey: userToken) ?? ""
    }
    
    func setUserToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: userToken)
    }
}



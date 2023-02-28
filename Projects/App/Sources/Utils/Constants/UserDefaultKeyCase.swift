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
    
    private let isPushAlarmOn = "isPushAlarmOn"
    
    func getIsPushAlarmOn() -> Bool {
        UserDefaults.standard.bool(forKey: isPushAlarmOn)
    }
    
    func setIsPushAlarmOn(_ isPushAlarm: Bool) {
        UserDefaults.standard.set(isPushAlarm, forKey: isPushAlarmOn)
    }
    
    private let userName = "userName"
    
    func getUserName() -> String {
        UserDefaults.standard.string(forKey: userName) ?? ""
    }
    
    func setUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: userName)
    }
    
}



//
//  DeviceManager.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/19.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import DeviceKit

private enum DeviceGroup {
    case homeButtonDevice
    var rawValue: [Device] {
        switch self {
        case .homeButtonDevice:
            return [.iPhone8, .iPhone8Plus, .iPhoneSE2, .iPhoneSE3, .simulator(.iPhoneSE3)]
        }
    }
}

class DeviceManager {
    static let shared: DeviceManager = DeviceManager()
    
    func isHomeButtonDevice() -> Bool {
        return Device.current.isOneOf(DeviceGroup.homeButtonDevice.rawValue)
    }
}

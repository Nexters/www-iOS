//
//  BaseResponseDTO.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/02.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

struct BaseResponseDTO: Codable {
    let code: Int
    let message: String
    let result: Result?
}

extension BaseResponseDTO {
    struct Result: Codable {
    }
}

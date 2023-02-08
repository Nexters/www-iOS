//
//  LoginResponseDTO.swift
//  www
//
//  Created by kokojong on 2023/02/05.
//

import Foundation

struct LoginResponseDTO: ModelType {
    let code: Int
    let message: String
    let result: Data
}

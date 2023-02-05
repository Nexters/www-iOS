//
//  SampleResponseDTO.swift
//  www
//
//  Created by Chanhee Jeong on 2023/02/01.
//

import Foundation

struct SampleResponseDTO {
    private enum CodingKeys: String, CodingKey {
        case name
        case age = "user_id"
    }
    let name: String
    let userId: Int
}

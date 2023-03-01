//
//  PlaceVoteResponseDTO.swift
//  App
//
//  Created by Chanhee Jeong on 2023/03/02.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import Foundation

// MARK: - MeetingPlaceResponseDTO
struct PlaceVoteResponseDTO: Codable {
    let code: Int
    let message: String
    let result: Result
}

extension PlaceVoteResponseDTO {
    
    struct Result: Codable {
        let userVoteList: [Vote]
        let myVoteList: [String]
        let votedUserCount: Int
    }

    struct Vote: Codable {
          let location: String
          let users: [String]

          init(from decoder: Decoder) throws {
              let container = try decoder.container(keyedBy: DynamicKey.self)
              guard let key = container.allKeys.first?.stringValue else {
                  throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "No keys in JSON object"))
              }
              location = key
              users = try container.decode([String].self, forKey: DynamicKey(keyValue: key))
          }

          func encode(to encoder: Encoder) throws {
              var container = encoder.container(keyedBy: DynamicKey.self)
              try container.encode(users, forKey: DynamicKey(keyValue: location))
          }
      }
    
    struct DynamicKey: CodingKey {
        let stringValue: String
        let intValue: Int?

        init(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }

        init(keyValue: String) {
            self.stringValue = keyValue
            self.intValue = nil
        }
    }

}

//
//  Message.swift
//  App
//
//  Created by Anton Sokolov on 26/02/2019.
//

import Foundation

struct Message: Codable {
    let user: Int
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case user
        case body
    }
}

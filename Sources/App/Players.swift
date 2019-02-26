//
//  Players.swift
//  App
//
//  Created by Anton Sokolov on 26/02/2019.
//

import Foundation
import Vapor

class Player: Encodable {
    static var count: Int = 1
    var id: Int
    var name: String
    var moves: Int
    var ws: WebSocket
    
    init(ws: WebSocket) {
        self.id = Player.count
        self.name = ""
        self.moves = 0
        self.ws = ws
        
        Player.count += 1
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case moves
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(moves, forKey: .moves)
    }
}

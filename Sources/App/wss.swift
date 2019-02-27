//
//  wss.swift
//  App
//
//  Created by Anton Sokolov on 25/02/2019.
//

import Vapor

var USERS: [WebSocket] = []
var PLAYERS = [Int:Player]()
var countdown: Int = 30


public func websockets(_ wss: NIOWebSocketServer) throws {
    
    // Add WebSocket upgrade support to GET /echo
    wss.get("echo") { ws, req in
        ws.send("Connected. Enter any text to test.")
        // Add a new on text callback
        ws.onText { ws, text in
            // Simply echo any received text
            //ws.send(text)
            for ws in USERS {
                ws.send(text)
            }
        }
        
        USERS.append(ws)
    }
    
    // Add WebSocket upgrade support to GET /chat/:name
    wss.get("chat", String.parameter) { ws, req in
        let name = try req.parameters.next(String.self)
        ws.send("Welcome, \(name)!")
        
        ws.onText {ws, text in
            ws.send(text)
        }
    }
    
    wss.get { ws, req in
        
        countdown = 30
        
        // Add a new on text callback
        ws.onText { ws, text in
            
            if countdown > 0 { return } // Если игра не началась на кнопки не реагируем
            
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let message = try JSONDecoder().decode(Message.self, from: text)
                
                guard let player = PLAYERS[message.user] else { return }
                
                switch message.body {
                case "move":
                    player.moves += 1
                    let playerId = player.id
                    for player in PLAYERS {
                        player.value.ws.send("{\"move\":\(playerId)}")
                    }
                case "done":
                    countdown = 30
                    let playerId = player.id
                    for player in PLAYERS {
                        player.value.ws.send("{\"done\":\(playerId)}")
                    }
                default:
                    break
                }
                
                let playerEncodedData = try? JSONEncoder().encode(player)
//                if let text = playerEncodedData {
//                    for player in PLAYERS {
//                        player.value.ws.send(text)
//                    }
//                }
    
            } catch let jsonError {
                print(jsonError)
            }
        }
        
        let player = Player(ws: ws)
        PLAYERS[player.id] = player
        
        //ws.send("Connected. Your id: \(player.id) Wait other players.")
        ws.send("{\"connected\":\(player.id)}")
        
        let playerEncodedData = try? JSONEncoder().encode(player)
        if let text = playerEncodedData {
            for player in PLAYERS {
                player.value.ws.send("{\"newplayer\":\(player.value.id)}")
                //player.value.ws.send(text)
            }
        }
        
    }
    
}

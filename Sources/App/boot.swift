import Routing
import Vapor

/// Called after your application has initialized.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#bootswift)
public func boot(_ app: Application) throws {
    func runRepeatTimer() {
        app.eventLoop.scheduleTask(in: TimeAmount.seconds(1), runRepeatTimer)
        gameLoop(on: app)
    }
    runRepeatTimer()
}

func gameLoop(on container: Container) {
    if countdown == 0 { return }
    for player in PLAYERS {
        player.value.ws.send("{\"timer\":\(countdown)}")
    }
    countdown -= 1
    if countdown < 1 {
        print("Game started")
        for player in PLAYERS {
            player.value.ws.send("{\"start\":\(player.value.id)}")
        }
    }
}

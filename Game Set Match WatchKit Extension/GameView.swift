//
//  GameView.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 17/07/2021.
//

import SwiftUI
import Foundation

struct GameView: View {
    
    @ObservedObject var game: Game
    var model = ViewModelWatch()
    
    init(game: Game) {
        self.game = game
    }
    
    var body: some View {
        VStack {
            // Score
            HStack {
                // Player
                VStack {
                    HStack {
                        Text("ME")
                        // Conditional service indicator
                        if (game.winner == "") {
                            Image(systemName: "circle.fill").font(.system(size: 6)).opacity(game.scoreBoard.toServe ? 1 : 0)
                        }
                    }
                    HStack {
                        Text("OP")
                        if (game.winner == "") {
                            Image(systemName: "circle.fill").font(.system(size: 6)).opacity(game.scoreBoard.toServe ? 0 : 1)
                        }
                    }
                }
                // Sets
                VStack {
                    Text(String(game.scoreBoard.setsUser))
                    Text(String(game.scoreBoard.setsOpponent))
                }
                // Games
                VStack {
                    Text(String(game.scoreBoard.gamesUser))
                    Text(String(game.scoreBoard.gamesOpponent))
                }
                // Points
                VStack {
                    Text(game.scoreBoard.pointsUser)
                    Text(game.scoreBoard.pointsOpponent)
                }
            }
            if (game.winner == "") {
                // Buttons for updating the score
                Button("Point won", action: {
                        game.newEvent(event: MatchEventType.win)
                    }
                )
                Button("Point lost", action: {
                        game.newEvent(event: MatchEventType.loss)
                    }
                )
                Button("Serve", action: {
                        game.newEvent(event: MatchEventType.firstServe)
                    }
                )
                Button("Undo", action: {
                        game.undoLastEvent()
                    }
                )
            } else {
                Button("Send to phone", action: {
                    let match = game.export()
                    
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    
                    do {
                        let data = try encoder.encode(match)
                        print(String(data: data, encoding: .utf8)!)
                        // message match
                        do {
                            try self.model.session?.updateApplicationContext(["match": data])
                        } catch {
                            print("something went wrong sending data")
                        }
                    } catch {
                        print("something went wrong encoding")
                    }
                })
            }
        }
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game(setsToWin: 2, gamesForSet: 6, firstServe: true))
    }
}

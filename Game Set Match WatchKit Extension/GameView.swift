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
                        game.newEvent(event: TennisEventType.win)
                    }
                )
                Button("Point lost", action: {
                        game.newEvent(event: TennisEventType.loss)
                    }
                )
            }
        }
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game(setsToWin: 2, gamesForSet: 6, firstServe: true))
    }
}

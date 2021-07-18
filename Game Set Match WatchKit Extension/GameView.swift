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
                // Sets
                VStack {
                    Text(String(game.setsUser))
                    Text(String(game.setsOpponent))
                }
                // Games
                VStack {
                    Text(String(game.gamesUser))
                    Text(String(game.gamesOpponent))
                }
                // Points
                VStack {
                    // Just use 0, 1, 2, etc during tie breaks
                    // Use score "NA" if unknown point value looked up in game.points
                    Text(game.setTieBreak ? String(game.pointsUser) : game.points[game.pointsUser] ?? "NA")
                    Text(game.setTieBreak ? String(game.pointsOpponent) : game.points[game.pointsOpponent] ?? "NA")
                }
            }
            if (game.winner == "") {
                // Buttons for updating the score
                Button("Point won", action: {
                        game.updateScore(pointWon: true)
                    }
                )
                Button("Point lost", action: {
                        game.updateScore(pointWon: false)
                    }
                )
            }
        }
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game(setsToWin: 2, gamesForSet: 6, toServe: 0))
    }
}

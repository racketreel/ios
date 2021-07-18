//
//  Game_Set_MatchApp.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 17/07/2021.
//

import SwiftUI

@main
struct Game_Set_MatchApp: App {
    
    @State private var step = 0
    
    @State private var setsToWin: Int = 2
    @State private var gamesForSet: Int = 6
    @State private var toServe: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if (step == 0) {
                Button("New Game", action: {
                    step += 1
                })
            } else if (step == 1) {
                Text("How many sets to win?")
                Button("1", action: {
                    setsToWin = 1
                    step += 1
                })
                Button("2", action: {
                    setsToWin = 2
                    step += 1
                })
                Button("3", action: {
                    setsToWin = 3
                    step += 1
                })
            } else if (step == 2) {
                Text("How many games per set?")
                Button("6", action: {
                    gamesForSet = 6
                    step += 1
                })
            } else if (step == 3) {
                Text("Who is serving first?")
                Button("Me", action: {
                    toServe = true
                    step += 1
                })
                Button("Opponent", action: {
                    toServe = false
                    step += 1
                })
            } else {
                // step == 4
                Button("End Game", action: {
                    step = 0
                })
                // Create Game with chosen options and display GameView of Game
                GameView(game: Game(setsToWin: setsToWin, gamesForSet: gamesForSet, toServe: toServe))
            }
        }
    }
}

//
//  Game.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 18/07/2021.
//

import Foundation

class Game: ObservableObject {
    
    private var setsToWin: Int
    private var gamesForSet: Int
    // 0=user, 1=opponent
    private var toServe: Int
    
    // Use alternate point scoring when set in a tie break
    @Published var setTieBreak: Bool = false
    
    @Published var setsUser: Int = 0
    @Published var setsOpponent: Int = 0
    @Published var gamesUser: Int = 0
    @Published var gamesOpponent: Int = 0
    // 0=0, 1=15, 2=30, 3=40, 4=adv
    @Published var pointsUser: Int = 0
    @Published var pointsOpponent: Int = 0
    
    // "" if game in progress
    @Published var winner: String = ""

    let points = [
        0: "0",
        1: "15",
        2: "30",
        3: "40",
        4: "AD"
    ]
    
    init (setsToWin: Int, gamesForSet: Int, toServe: Int) {
        self.setsToWin = setsToWin
        self.gamesForSet = gamesForSet
        self.toServe = toServe
        
        print(gamesForSet)
        print(setsToWin)
    }
    
    func updateScore(pointWon: Bool) {
        // Do not update if there is a winner
        if (winner != "") {
            return
        }
        
        var gameOver = false
        var setOver = false
        
        // Score points
        if setTieBreak {
            // Score differently when in a tie break
            if pointWon {
                self.pointsUser += 1
            } else {
                self.pointsOpponent += 1
            }
        } else {
            // Otherwise, score points normally
            if pointWon {
                // If opponent was on advantage put it back to duece
                if (pointsOpponent == 4) {
                    self.pointsOpponent -= 1
                } else {
                    // Otherwise just increment points
                    self.pointsUser += 1
                }
            } else {
                // If user was on advantage put it back to duece
                if (pointsUser == 4) {
                    self.pointsUser -= 1
                } else {
                    // Otherwise just increment points
                    self.pointsOpponent += 1
                }
            }
        }
        
        // Check if the game is won
        if setTieBreak {
            // Check if the game is won by user
            // First to 7 points
            // If 6-6 then first to win two in a row
            if (self.pointsUser >= 7 && self.pointsUser >= (self.pointsOpponent + 2)) {
                // Add a game to the user
                self.gamesUser += 1
                // Set flag to clean up game score
                gameOver = true
                // End tie break
                self.setTieBreak = false
            }
            
            // Todo: Tidy repeated code for each player
            // Check if game is won by opponent
            if (self.pointsOpponent >= 7 && self.pointsOpponent >= (self.pointsUser + 2)) {
                // Add a set to the opponent
                self.gamesOpponent += 1
                // Set flag to clean up game score
                gameOver = true
                // End tie break
                self.setTieBreak = false
            }
        } else {
            // Check if the game is won by user
            if ((self.pointsUser == 4 && self.pointsOpponent < 3) || self.pointsUser == 5) {
                // Add a game to the user
                self.gamesUser += 1
                // Set flag to clean up game score
                gameOver = true
            }
            
            // Todo: Tidy repeated code for each player
            // Check if game is won by opponent
            if ((self.pointsOpponent == 4 && self.pointsUser < 3) || self.pointsOpponent == 5) {
                // Add a game to the opponent
                self.gamesOpponent += 1
                // Set flag to clean up game score
                gameOver = true
            }
        }
        
        if gameOver {
            // Reset score of game
            self.pointsUser = 0
            self.pointsOpponent = 0
            
            // Check if set is won by user
            // 8 games is a win by tie break
            if ((self.gamesUser >= self.gamesForSet && self.gamesUser >= (self.gamesOpponent + 2)) || self.gamesUser == self.gamesForSet + 2) {
                // Add set to user
                self.setsUser += 1
                // Set flag to clean up set score
                setOver = true
            }
            
            // Todo: Tidy repeated code for each player
            // Check if set is won by opponent
            if ((self.gamesOpponent >= self.gamesForSet && self.gamesOpponent >= (self.gamesUser + 2)) || self.gamesOpponent == self.gamesForSet + 2) {
                // Add set to opponent
                self.setsOpponent += 1
                // Set flag to clean up set score
                setOver = true
            }
            
            // Check if this set is in a tie break
            if (self.gamesUser  == self.gamesForSet + 1 && self.gamesOpponent == self.gamesForSet + 1) {
                // Set setTieBreak flag for alternate scoring
                setTieBreak = true
            }
        }
        
        if setOver {
            // Reset score of set
            self.gamesUser = 0
            self.gamesOpponent = 0
            
            // Check if match is won by user
            if (self.setsUser == self.setsToWin) {
                // Match win for user
                self.winner = "user"
            }
            
            // Check if match is won by opponent
            if (self.setsOpponent == self.setsToWin) {
                // Match loss for user
                self.winner = "opponent"
            }
        }
    }
    
}

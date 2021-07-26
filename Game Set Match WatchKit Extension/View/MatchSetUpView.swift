//
//  MatchSetUpView.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct MatchSetUpView: View {
    
    private enum SetUpStage {
        case setsToWin
        case gamesPerSet
        case firstServe
    }
    
    @State private var setUpStage = SetUpStage.setsToWin
    @State private var matchPreferences = MatchPreferences()
    
    @ObservedObject var model: ViewModelWatch
    
    var body: some View {
        VStack {
            if (setUpStage == SetUpStage.setsToWin) {
                Text("How many sets to win?")
                Button("1", action: {
                    self.matchPreferences.setsToWin = 1
                    setUpStage = SetUpStage.gamesPerSet
                })
                Button("2", action: {
                    self.matchPreferences.setsToWin = 2
                    setUpStage = SetUpStage.gamesPerSet
                })
                Button("3", action: {
                    self.matchPreferences.setsToWin = 3
                    setUpStage = SetUpStage.gamesPerSet
                })
            }
            if (setUpStage == SetUpStage.gamesPerSet) {
                Text("How many games per set?")
                Button("6", action: {
                    self.matchPreferences.gamesForSet = 6
                    setUpStage = SetUpStage.firstServe
                })
            }
            if (setUpStage == SetUpStage.firstServe) {
                Text("Who is serving first?")
                Button("Me", action: {
                    self.matchPreferences.firstServe = true
                    model.currentView = ViewType.matchInProgress
                    
                    model.newMatch(matchPreferences: self.matchPreferences)
                })
                Button("Opponent", action: {
                    self.matchPreferences.firstServe = false
                    model.currentView = ViewType.matchInProgress
                    
                    model.newMatch(matchPreferences: self.matchPreferences)
                })
            }
        }
    }
        
}

struct MatchSetUpView_Previews: PreviewProvider {
    static var previews: some View {
        MatchSetUpView(model: ViewModelWatch())
    }
}

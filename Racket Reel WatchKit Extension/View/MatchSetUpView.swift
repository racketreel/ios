//
//  MatchSetUpView.swift
//  Racket Reel WatchKit Extension
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
    // Defaults
    @State var setsToWin: Int = 2
    @State var gamesForSet: Int = 6
    @State var servingFirst: TeamNumber = TeamNumber.One
    
    @ObservedObject var model: ViewModel
    
    var body: some View {
        VStack {
            if (setUpStage == SetUpStage.setsToWin) {
                Text("How many sets to win?")
                Button("1", action: {
                    self.setsToWin = 1
                    setUpStage = SetUpStage.gamesPerSet
                })
                Button("2", action: {
                    self.setsToWin = 2
                    setUpStage = SetUpStage.gamesPerSet
                })
                Button("3", action: {
                    self.setsToWin = 3
                    setUpStage = SetUpStage.gamesPerSet
                })
            }
            if (setUpStage == SetUpStage.gamesPerSet) {
                Text("How many games per set?")
                Button("6", action: {
                    self.gamesForSet = 6
                    setUpStage = SetUpStage.firstServe
                })
            }
            if (setUpStage == SetUpStage.firstServe) {
                Text("Who is serving first?")
                Button("Me", action: {
                    self.servingFirst = TeamNumber.One
                    model.currentView = ViewType.matchInProgress
                    createMatch()
                })
                Button("Opponent", action: {
                    self.servingFirst = TeamNumber.Two
                    model.currentView = ViewType.matchInProgress
                    createMatch()
                })
            }
        }
    }
    
    private func createMatch() {
        // Hardcode defaults for preferences not yet in UI.
        model.newtMatch(preferences: TennisPreferences(
            sets: self.setsToWin,
            games: self.gamesForSet,
            timestamp: Date(),
            initialServe: self.servingFirst,
            finalSetTieBreak: false,
            pointsForTieBreak: 7,
            teams: TeamMembersWrapper(dict: [
                TeamNumber.One: Team(number: TeamNumber.One, membership: TeamMembershipType.Singles, members: []),
                TeamNumber.Two: Team(number: TeamNumber.Two, membership: TeamMembershipType.Singles, members: [])
            ]))
        )
    }
        
}

struct MatchSetUpView_Previews: PreviewProvider {
    static var previews: some View {
        MatchSetUpView(model: ViewModel())
    }
}

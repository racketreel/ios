//
//  ScoreBoardView.swift
//  Racket Reel WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct ScoreBoardView: View {
    
    let tState: TennisState
    
    var body: some View {
        HStack {
            // Player
            VStack {
                HStack {
                    Text("ME")
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .opacity(tState.serving == TeamNumber.One ? 1 : 0)
                }
                HStack {
                    Text("OP")
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .opacity(tState.serving == TeamNumber.Two ? 1 : 0)
                }
            }
            // Sets
            VStack {
                Text(String(tState.scores[TeamNumber.One]!.sets))
                Text(String(tState.scores[TeamNumber.Two]!.sets))
            }
            // Games
            VStack {
                Text(String(tState.scores[TeamNumber.One]!.games))
                Text(String(tState.scores[TeamNumber.Two]!.games))
            }
            // Points
            VStack {
                Text(displayablePoint(team: TeamNumber.One))
                Text(displayablePoint(team: TeamNumber.Two))
            }
        }
    }
    
    func displayablePoint(team: TeamNumber) -> String {
        let intPoints = self.tState.scores[team]!.points
        if tState.isTieBreak {
            return String(intPoints)
        } else {
            return TennisPoint(rawValue: intPoints)?.forScoreboard ?? "ERR"
        }
    }
    
}

struct ScoreBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoardView(tState: TennisMatch.empty.initialState)
    }
}

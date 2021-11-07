//
//  LoggingScoreView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 29/10/2021.
//

import SwiftUI

struct LoggingScoreView: View {
    
    let state: TennisState
    let preferences: TennisPreferences
    
    var body: some View {
        VStack {
            // Player/Team One
            HStack {
                if (state.serving == TeamNumber.One) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                }
                Text(preferences.teams.dict[TeamNumber.One]!.name)
                    
            }
            HStack {
                Text(String(state.scores[TeamNumber.One]!.sets))
                    .frame(width: 40, height: .none, alignment: .center)
                Text(String(state.scores[TeamNumber.One]!.games))
                    .frame(width: 40, height: .none, alignment: .center)
                Text(state.scores[TeamNumber.One]!.pointsToString(isTieBreak: state.isTieBreak))
                    .frame(width: 40, height: .none, alignment: .center)
            }
            .padding(5)
            .font(.title)
            Rectangle()
                .fill(Color.gray)
                .frame(width: 75, height: 1)
            // Player/Team Two
            HStack {
                Text(String(state.scores[TeamNumber.Two]!.sets))
                    .frame(width: 40, height: .none, alignment: .center)
                Text(String(state.scores[TeamNumber.Two]!.games))
                    .frame(width: 40, height: .none, alignment: .center)
                Text(state.scores[TeamNumber.Two]!.pointsToString(isTieBreak: state.isTieBreak))
                    .frame(width: 40, height: .none, alignment: .center)
            }
            .padding(5)
            .font(.title)
            HStack {
                if (state.serving == TeamNumber.Two) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                }
                Text(preferences.teams.dict[TeamNumber.Two]!.name)
            }
        }
        .padding(40)
        .background(Color.white)
        .cornerRadius(20)
        .padding(20)
    }
}

struct LoggingScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                LoggingScoreView(
                    state: TennisMatch.inProgress.states.last!,
                    preferences: TennisMatch.inProgress.preferences
                )
                LoggingScoreView(
                    state: TennisMatch.empty.initialState,
                    preferences: TennisPreferences(
                        sets: 2,
                        games: 6,
                        timestamp: Date(),
                        initialServe: TeamNumber.Two,
                        finalSetTieBreak: false,
                        pointsForTieBreak: 7,
                        teams: TeamMembersWrapper(dict: [
                            TeamNumber.One: Team(
                                number: TeamNumber.One,
                                membership: TeamMembershipType.Doubles,
                                members: [
                                    TeamMember(
                                        firstname: "Tom",
                                        surname: "Elvidge"
                                    ),
                                    TeamMember(
                                        firstname: "Joe",
                                        surname: "Frankish"
                                    )
                                ]
                            ),
                            TeamNumber.Two: Team(
                                number: TeamNumber.Two,
                                membership: TeamMembershipType.Doubles,
                                members: [
                                    TeamMember(
                                        firstname: "Emma",
                                        surname: "Raducanu"
                                    ),
                                    TeamMember(
                                        firstname: "Andy",
                                        surname: "Murray"
                                    )
                                ]
                            )
                        ])
                    )
                )
            }
        }
    }
}

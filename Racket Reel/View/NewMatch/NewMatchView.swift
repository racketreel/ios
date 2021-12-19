//
//  LoggingView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 20/10/2021.
//

import SwiftUI

struct NewMatchView: View {
    
    @ObservedObject var viewModel = NewMatchViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Custom background color.
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Players")
                            .font(.title2)
                        
                        NewMatchPlayersView(
                            teamType: $viewModel.teamType,
                            initialServe: $viewModel.initalServe,
                            teamOnePlayerOne: $viewModel.teamOnePlayerOne,
                            teamOnePlayerTwo: $viewModel.teamOnePlayerTwo,
                            teamTwoPlayerOne: $viewModel.teamTwoPlayerOne,
                            teamTwoPlayerTwo: $viewModel.teamTwoPlayerTwo
                        )
                        
                        Text("Preferences")
                            .font(.title2)
                        
                        NewMatchSetsView(sets: $viewModel.sets)
                        NewMatchGamesView(games: $viewModel.games)
                        NewMatchTieBreakView(
                            finalSetTieBreak: $viewModel.finalSetTieBreak,
                            pointsForTieBreak: $viewModel.pointsForTieBreak
                        )
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Match")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Start") {
                        viewModel.start()
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.showMatchStartAlert) {
            Alert(
                title: Text(viewModel.matchStartAlertTitle),
                message: Text(viewModel.matchStartAlertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .actionSheet(isPresented: $viewModel.showSelectLoggingDeviceSheet) {
            ActionSheet(
                title: Text("Select a device to log with"),
                buttons: [
                    .default(Text(LoggingDevice.this.rawValue)) {
                        viewModel.startMatchOn(LoggingDevice.this)
                    },
                    .default(Text(LoggingDevice.appleWatch.rawValue)) {
                        viewModel.startMatchOn(LoggingDevice.appleWatch)
                    },
                    .cancel()
                ]
            )
        }
        .sheet(
            isPresented: $viewModel.showLoggingView,
            onDismiss: viewModel.matchExited,
            content: { LoggingView(match: $viewModel.match) }
        )
    }
}

struct NewMatchView_Previews: PreviewProvider {
    static var previews: some View {
        NewMatchView()
    }
}

//
//  LoggingView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 26/10/2021.
//

import SwiftUI

struct LoggingView: View {
    
    @Binding var match: TennisMatch?
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = LoggingViewModel()
    
    var body: some View {
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            if (match == nil) {
                Text("No match...")
            } else {
                VStack(alignment: .center) {
                    LoggingScoreView(state: match!.lastState, preferences: match!.preferences)
                    HStack {
                        if (match!.lastState.isSecondServe) {
                            LoggingButton(
                                text: "Second Serve",
                                enabled: viewModel.enableButton(forEvent: TennisEventType.SecondServe, after: match?.lastEvent?.type),
                                action: { viewModel.update(match: match!, with: TennisEventType.SecondServe) }
                            )
                        } else {
                            LoggingButton(
                                text: "First Serve",
                                enabled: viewModel.enableButton(forEvent: TennisEventType.FirstServe, after: match?.lastEvent?.type),
                                action: { viewModel.update(match: match!, with: TennisEventType.FirstServe) }
                            )
                        }
                        LoggingButton(
                            text: "Let",
                            enabled: viewModel.enableButton(forEvent: TennisEventType.Let, after: match?.lastEvent?.type),
                            action: { viewModel.update(match: match!, with: TennisEventType.Let) }
                        )
                    }
                    HStack {
                        LoggingButton(
                            text: "Point to \(match!.preferences.teams.dict[TeamNumber.One]!.name)",
                            enabled: viewModel.enableButton(forEvent: TennisEventType.TeamOnePoint, after: match?.lastEvent?.type),
                            action: { viewModel.update(match: match!, with: TennisEventType.TeamOnePoint) }
                        )
                        LoggingButton(
                            text: "Point to \(match!.preferences.teams.dict[TeamNumber.Two]!.name)",
                            enabled: viewModel.enableButton(forEvent: TennisEventType.TeamTwoPoint, after: match?.lastEvent?.type),
                            action: { viewModel.update(match: match!, with: TennisEventType.TeamTwoPoint) }
                        )
                    }
                    HStack {
                        LoggingButton(
                            text: "Fault",
                            enabled: viewModel.enableButton(forEvent: TennisEventType.Fault, after: match?.lastEvent?.type),
                            action: { viewModel.update(match: match!, with: TennisEventType.Fault) }
                        )
                        LoggingButton(
                            text: "Undo",
                            enabled: (match?.lastEvent != nil),
                            action: { viewModel.undo(match: match!) }
                        )
                    }
                    Text(viewModel.lastEventText(match: match!))
                }
                    .padding()
                    .alert(isPresented: $viewModel.showCompleteAlert) {
                        Alert(
                            title: Text("Match Over"),
                            message: Text("The match has been saved."),
                            dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                                match = nil
                            }
                        )
                    }
                Button {
                    viewModel.showQuitAlert = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color("CustomGray"))
                        .font(.title)
                }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .alert(isPresented: $viewModel.showQuitAlert) {
                        Alert(
                            title: Text("Quit Match"),
                            message: Text("Are you sure you want to quit?"),
                            primaryButton: .default(Text("Quit"), action: {
                                presentationMode.wrappedValue.dismiss()
                                match = nil
                            }),
                            secondaryButton: .cancel()
                        )
                    }
            }
        }
//            .interactiveDismissDisabled()
    }
}

struct LoggingView_Previews: PreviewProvider {
    static var previews: some View {
        LoggingView(match: .constant(TennisMatch.inProgress))
    }
}

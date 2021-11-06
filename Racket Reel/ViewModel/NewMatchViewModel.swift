//
//  NewMatchViewModel.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 23/10/2021.
//

import Foundation

class NewMatchViewModel: ObservableObject {
    
    // Tennis match preferences...
    @Published var teamType = TeamMembershipType.Singles
    @Published var teamOnePlayerOne = TeamMember(firstname: "", surname: "")
    @Published var teamOnePlayerTwo = TeamMember(firstname: "", surname: "")
    @Published var teamTwoPlayerOne = TeamMember(firstname: "", surname: "")
    @Published var teamTwoPlayerTwo = TeamMember(firstname: "", surname: "")
    // Sets required to win match
    @Published var sets = 1
    // Games required to win set
    @Published var games = 6
    // Tie break
    @Published var finalSetTieBreak = true
    @Published var pointsForTieBreak = 7
    @Published var initalServe = TeamNumber.One
    
    @Published var showSelectLoggingDeviceSheet = false
    
    @Published var showMatchStartAlert = false
    @Published var matchStartAlertTitle = ""
    @Published var matchStartAlertMessage = ""
    
    @Published var showLoggingView = false
    @Published var match: TennisMatch? // To pass to LoggingView
    
    @Inject var auth: AuthenticationProvider
    
    private func resetFieldsToDefaults() {
        teamType = TeamMembershipType.Singles
        teamOnePlayerOne = TeamMember(firstname: "", surname: "")
        teamOnePlayerTwo = TeamMember(firstname: "", surname: "")
        teamTwoPlayerOne = TeamMember(firstname: "", surname: "")
        teamTwoPlayerTwo = TeamMember(firstname: "", surname: "")
        sets = 1
        games = 6
        finalSetTieBreak = true
        pointsForTieBreak = 7
        initalServe = TeamNumber.One
    }

    private func connectedAppleWatch() -> Bool {
        // Todo: Inject watch service so can check if one is connected.
        return true
    }
    
    private func requiredNamesAreEmpty() -> Bool {
        if ((self.teamOnePlayerOne.firstname == "")
            || (self.teamOnePlayerOne.surname == "")
            || (self.teamTwoPlayerOne.surname == "")
            || (self.teamTwoPlayerOne.surname == "")) {
            return true
        } else {
            // When doubles also check player two in each time.
            if ((self.teamType == TeamMembershipType.Doubles)
                && (
                    (self.teamOnePlayerTwo.firstname == "")
                    || (self.teamOnePlayerTwo.surname == "")
                    || (self.teamTwoPlayerTwo.surname == "")
                    || (self.teamTwoPlayerTwo.surname == "")
                )) {
                return true
            } else {
                return false
            }
        }
    }
    
    func start() {
        // Ensure all names have been entered.
        if requiredNamesAreEmpty() {
            self.matchStartAlertTitle = "Cannot Start Match"
            self.matchStartAlertMessage = "One or more of the player names are empty."
            self.showMatchStartAlert = true
            return
        }
        
        // Todo: If user not subscribed and has a connected apple watch then alert about subscribing.
        
        // Multiple device options, so let the user choose.
        if connectedAppleWatch() {
            self.showSelectLoggingDeviceSheet = true
        } else {
            // Otherwise default to this device.
            startMatchOn(LoggingDevice.this)
        }
    }
    
    func startMatchOn(_ device: LoggingDevice) {
        // Construct a new TennisMatch object.
        let match = TennisMatch(
            createdByUserId: auth.user!.id,
            preferences: TennisPreferences(
                sets: self.sets,
                games: self.games,
                timestamp: Date(),
                initialServe: self.initalServe,
                finalSetTieBreak: self.finalSetTieBreak,
                pointsForTieBreak: self.pointsForTieBreak,
                teams: TeamMembersWrapper(dict: [
                    TeamNumber.One: Team(
                        number: TeamNumber.One,
                        membership: self.teamType,
                        members: [self.teamOnePlayerOne]
                    ),
                    TeamNumber.Two: Team(
                        number: TeamNumber.Two,
                        membership: self.teamType,
                        members: [self.teamTwoPlayerOne]
                    )
                ])
            )
        )
        // Add second players if Doubles.
        if (self.teamType == TeamMembershipType.Doubles) {
            match.preferences.teams.dict[TeamNumber.One]!.members.append(teamOnePlayerTwo)
            match.preferences.teams.dict[TeamNumber.Two]!.members.append(teamTwoPlayerTwo)
        }
        
        // Todo: Validate match is OK.
        
        // Start the match (enables logging).
        do {
            try match.startMatch()
        } catch {
            // Should never happen but log if it does.
            print(error.localizedDescription)
            // Alert so not silently failing.
            self.matchStartAlertTitle = "Cannot Start Match"
            self.matchStartAlertMessage = "There was an error when starting the match. If this persists please contact support."
            self.showMatchStartAlert = true
            return
        }
        
        if (device == LoggingDevice.this) {
            self.match = match
            self.showLoggingView = true
        } else { // device == LoggingDevice.appleWatch
            // Todo: Send match to Apple Watch.
            
            // Todo: If not success.
//                print(error.localizedDescription)
//                self.matchStartAlertTitle = "Cannot Start Match"
//                self.matchStartAlertMessage = "There was an error sending the match to your Apple Watch. If this persists please contact support."
//                self.showMatchStartAlert = true
//                return

            // Otherwise the match was sent to the Apple Watch.
            // Display alert to user.
            self.matchStartAlertTitle = "Done"
            self.matchStartAlertMessage = "The match has been started on your connected Apple Watch."
            self.showMatchStartAlert = true
        }
        
        // Match was successfull started.
        self.resetFieldsToDefaults()
    }
    
    func matchExited() {
        // Discard the match.
        self.match = nil
    }
    
}

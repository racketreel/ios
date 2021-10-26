//
//  NewMatchPlayersView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 24/10/2021.
//

import SwiftUI

struct NewMatchTeamMemberView: View {
    
    @Binding var teamMember: TeamMember
    var playerNumber: Int
    
    var body: some View {
        HStack {
            Text(String(playerNumber))
            TextField("Firstname", text: self.$teamMember.firstname)
            TextField("Surname", text: self.$teamMember.surname)
        }
    }
    
}

struct NewMatchPlayersView: View { 
    
    @Binding var teamType: TeamMembershipType
    @Binding var initialServe: TeamNumber
    
    // Todo: Remove duplicate code...
    
    // Team.One
    @Binding var teamOnePlayerOne: TeamMember
    @Binding var teamOnePlayerTwo: TeamMember
    // Team.Two
    @Binding var teamTwoPlayerOne: TeamMember
    @Binding var teamTwoPlayerTwo: TeamMember
    
    private var singlesSelected: Bool {
        get {
            return self.teamType == TeamMembershipType.Singles
        }
    }
    
    private var teamOneServing: Bool {
        get {
            return self.initialServe == TeamNumber.One
        }
    }
    
    private var teamOneName: String {
        get {
            if singlesSelected {
                return "Player One"
            } else {
                return "Team One"
            }
        }
    }
    
    private var teamTwoName: String {
        get {
            if singlesSelected {
                return "Player Two"
            } else {
                return "Team Two"
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button("Singles", action: {
                    self.teamType = TeamMembershipType.Singles
                })
                    .buttonStyle(SelectableButtonStyle(selected: self.singlesSelected))
                Button("Doubles", action: {
                    self.teamType = TeamMembershipType.Doubles
                })
                    .buttonStyle(SelectableButtonStyle(selected: !self.singlesSelected))
            }
            
            if (self.teamType == TeamMembershipType.Doubles) { Text("Team") }
            
            NewMatchTeamMemberView(teamMember: self.$teamOnePlayerOne, playerNumber: 1)
            
            if (self.teamType == TeamMembershipType.Doubles) {
                NewMatchTeamMemberView(teamMember: self.$teamOnePlayerTwo, playerNumber: 2)
                Text("Team")
            }
            
            // In singles this is player 2, but in doubles it is player 3.
            NewMatchTeamMemberView(teamMember: self.$teamTwoPlayerOne, playerNumber: (self.teamType == TeamMembershipType.Singles ? 2 : 3))
            
            if (self.teamType == TeamMembershipType.Doubles) {
                NewMatchTeamMemberView(teamMember: self.$teamTwoPlayerTwo, playerNumber: 4)
            }
            
            Text("Who is serving first?")
            HStack {
                Button(teamOneName, action: {
                    self.initialServe = TeamNumber.One
                })
                    .buttonStyle(SelectableButtonStyle(selected: self.teamOneServing))
                Button(teamTwoName, action: {
                    self.initialServe = TeamNumber.Two
                })
                    .buttonStyle(SelectableButtonStyle(selected: !self.teamOneServing))
            }
        }
        .textFieldStyle(RRTextFieldStyle())
    }
}

struct NewMatchPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        NewMatchPlayersView(
            teamType: .constant(TeamMembershipType.Doubles),
            initialServe: .constant(TeamNumber.One),
            teamOnePlayerOne: .constant(TeamMember(firstname: "", surname: "")),
            teamOnePlayerTwo: .constant(TeamMember(firstname: "", surname: "")),
            teamTwoPlayerOne: .constant(TeamMember(firstname: "", surname: "")),
            teamTwoPlayerTwo: .constant(TeamMember(firstname: "", surname: ""))
        )
    }
}

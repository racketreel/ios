//
//  LoggingViewModel.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 29/10/2021.
//

import Foundation

class LoggingViewModel: ObservableObject {
    
    @Published var showCompleteAlert = false
    @Published var showQuitAlert = false
    
    @Inject var auth: AuthenticationProvider
    @Inject var userInfo: AnyDataProvider<UserInfo>
    @Inject var matches: AnyDataProvider<TennisMatch>
    
    func lastEventText(match: TennisMatch) -> String {
        if (match.lastEvent != nil) {
            return "Last event was a " + match.display(event: match.lastEvent!.type)
        } else {
            return ""
        }
    }
    
    func update(match: TennisMatch, with: TennisEventType) {
        do {
            objectWillChange.send()
            try match.logEvent(with)
        } catch {
            // Todo: Display an alert if something went wrong.
            print(error.localizedDescription)
        }
        
        if (!match.inProgress) {
            self.saveToMatches(match: match)
            showCompleteAlert = true
        }
    }
    
    private func saveToMatches(match: TennisMatch) {
        if (self.auth.user != nil) {
            self.matches.create(match, completion: { error in
                // Something went wrong
                if (error != nil) {
                    print(error!.localizedDescription)
                    return
                }
                // If match has been saved then create reference in userInfo
                self.saveToUserInfo(match: match)
            })
        }
    }
    
    private func saveToUserInfo(match: TennisMatch) {
        if (self.auth.user != nil) {
            self.userInfo.read(id: self.auth.user!.id, completion: { error, userInfo in
                if (error != nil) {
                    // Something went wrong getting the current user info
                    print(error!.localizedDescription)
                } else {
                    // Update matches array
                    var newMatches = userInfo!.matchIds
                    newMatches.append(match.id)
                    // Create new userInfo
                    let newUserInfo = UserInfo(
                        id: userInfo!.id,
                        firstname: userInfo!.firstname,
                        surname: userInfo!.surname,
                        matchIds: newMatches
                    )
                    // Update user info
                    self.userInfo.update(
                        id: newUserInfo.id,
                        with: newUserInfo,
                        completion: { error in
                            if (error != nil) {
                                // Something went wrong updating user info
                                print(error!.localizedDescription)
                            }
                        }
                    )
                }
            })
        }
    }
    
    func enableButton(forEvent: TennisEventType, after: TennisEventType?) -> Bool {
        // After is nil then it is the first event.
        if (after == nil) {
            // Only first serve allowed as the initial event.
            if (forEvent == TennisEventType.FirstServe) {
                return true
            } else {
                return false
            }
        }
        
        if (after!.validNextStates().contains(forEvent)) {
            return true
        }
        
        return false
    }
    
    func undo(match: TennisMatch) {
        do {
            objectWillChange.send()
            try match.undoLastEvent()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

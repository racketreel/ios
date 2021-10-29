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
            // Todo: Save match to user
            print("match over")
            showCompleteAlert = true
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

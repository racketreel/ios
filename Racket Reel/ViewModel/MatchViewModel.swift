//
//  MatchViewModel.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 09/11/2021.
//

import Foundation

class MatchViewModel: ObservableObject {
    
    let match: TennisMatch
    
    init(match: TennisMatch) {
        self.match = match
    }
    
    func display(event: TennisEvent) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let stime = formatter.string(from: event.timestamp)
        
        var sevent = self.match.display(event: event.type)
        sevent = sevent.first!.uppercased() + sevent.dropFirst()
        
        return "\(sevent) at \(stime)"
    }
    
}

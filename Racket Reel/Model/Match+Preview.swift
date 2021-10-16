//
//  Match+Preview.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 29/08/2021.
//

import Foundation
import CoreData

extension Match {
    
    public static var example: Match {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Match> = Match.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? context.fetch(fetchRequest)
        return (results?.first!)!
    }
    
}

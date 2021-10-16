//
//  MatchViewModel.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 16/08/2021.
//

import Foundation
import AVFoundation
import PhotosUI

class MatchViewModel: ObservableObject {
    
    @Published var match: Match
    
    init (match: Match) {
        self.match = match
    }
    
    func exportMatch() -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let data = try encoder.encode(match)
            encoder.outputFormatting = .prettyPrinted
            // Debug
            print(String(data: data, encoding: .utf8)!)
            return data
        } catch {
            print("Unable to encode match: \(error.localizedDescription)")
        }
        return nil
    }
    
}

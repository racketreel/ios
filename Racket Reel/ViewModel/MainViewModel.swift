//
//  MatchViewModel.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 16/08/2021.
//

import Foundation
//import AVFoundation
//import PhotosUI

class MainViewModel: ObservableObject {
    
    @Inject var auth: AuthenticationProvider
    @Inject var userInfoProvider: AnyDataProvider<UserInfo>
    @Inject var matchesProvider: AnyDataProvider<TennisMatch>
    
    @Published var matches: [TennisMatch] = []
    
    init() {
       updateMatches()
    }
    
    func updateMatches() {
        // Clear matches
        self.matches = []
        
        if (auth.user == nil) {
            return
        }
        
        self.userInfoProvider.read(id: auth.user!.id, completion: { error, userInfo in
            // Cannot get user info
            if (error != nil) {
                print(error!.localizedDescription)
                return
            }
            
            for id in userInfo!.matchIds {
                self.matchesProvider.read(id: id, completion: { error, match in
                    // Cannot get match
                    if (error != nil) {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    // Add match
                    if (match != nil) {
                        self.matches.append(match!)
                    }
                })
            }
        })
    }
    
    func deleteMatches(at offsets: IndexSet) {
        for index in offsets {
            let match = matches[index]
            self.matchesProvider.delete(id: match.id, completion: { error in
                if (error == nil) {
                    self.matches.remove(at: index)
                    self.removeFromUserInfo(matchId: match.id)
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
    private func removeFromUserInfo(matchId: String) {
        self.userInfoProvider.read(id: auth.user!.id, completion: { error, userInfo in
            if (error != nil) {
                print(error!.localizedDescription)
                return
            }
            
            if (userInfo != nil) {
                var updatedMatchIds = userInfo!.matchIds
                updatedMatchIds.removeAll(where: { $0 == matchId })
                
                let updatedUserInfo = UserInfo(
                    id: userInfo!.id,
                    firstname: userInfo!.firstname,
                    surname: userInfo!.surname,
                    matchIds: updatedMatchIds
                )
                
                self.userInfoProvider.update(id: userInfo!.id, with: updatedUserInfo, completion: { error in
                    if (error != nil) {
                        print(error!.localizedDescription)
                    }
                })
            }
        })
    }
    
//    func exportMatch() -> Data? {
//        let encoder = JSONEncoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        do {
//            let data = try encoder.encode(match)
//            encoder.outputFormatting = .prettyPrinted
//            // Debug
//            print(String(data: data, encoding: .utf8)!)
//            return data
//        } catch {
//            print("Unable to encode match: \(error.localizedDescription)")
//        }
//        return nil
//    }
    
}

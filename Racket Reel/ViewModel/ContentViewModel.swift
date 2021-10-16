//
//  ContentViewModel.swift
//  RacketReel
//
//  Created by Tom Elvidge on 08/10/2021.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var isSignedIn: Bool
    @Published var user: User?
    
    public var auth: AuthProtocol
    
    init(auth: AuthProtocol) {
        self.auth = auth
        self.isSignedIn = false
        
        self.auth.addUserObserver { user in
            self.isSignedIn = user != nil
            self.user = user
        }
    }
    
    func sendEmailVerification() {
        auth.sendEmailVerification(completion: { error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
        })
    }
    
}

//
//  ContentViewModel.swift
//  RacketReel
//
//  Created by Tom Elvidge on 08/10/2021.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var isSignedIn: Bool
    @Published var user: AuthenticationUser?
    @Published var tabSelected = 2 // Default to MainView.
    
    @Inject var auth: AuthenticationProvider
    
    init() {
        self.isSignedIn = false
        
        self.auth.addUserObserver { user in
            self.isSignedIn = user != nil
            self.user = user
        }
    }
    
    func sendEmailVerification() {
        self.auth.sendEmailVerification(completion: { error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
        })
    }
    
}

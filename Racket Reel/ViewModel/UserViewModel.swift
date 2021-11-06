//
//  UserViewModel.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 23/10/2021.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Inject var auth: AuthenticationProvider
    
    func logOut() {
        self.auth.logOut { error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
        }
    }
    
}

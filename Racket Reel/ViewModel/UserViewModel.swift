//
//  UserViewModel.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 23/10/2021.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Inject var auth: AuthProtocol
    
    func logOut() {
        self.auth.logOut { error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
        }
    }
    
}

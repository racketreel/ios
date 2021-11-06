//
//  PreviewAuthenticationProvider.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation

class PreviewAuthenticationProvider: AuthenticationProvider {
    
    var user: AuthenticationUser? {
        didSet {
            for observer in userObservers {
                observer(self.user)
            }
        }
    }
    
    var userObservers: [AuthenticationUserUpdate] = []
    
    func addUserObserver(_ handler: @escaping AuthenticationUserUpdate) {
        userObservers.append(handler)
    }
    
    func logIn(email: String, password: String, completion: @escaping AuthenticationOperation) {
        self.user = AuthenticationUser(
            id: UUID().uuidString,
            email: "tom@racketreel.com",
            verified: false
        )
        completion(nil)
    }
    
    func logOut(completion: @escaping AuthenticationOperation) {
        self.user = nil
        completion(nil)
    }
    
    func register(email: String, password: String, completion: @escaping AuthenticationOperation) {
        self.user = AuthenticationUser(
            id: UUID().uuidString,
            email: email,
            verified: false
        )
        completion(nil)
    }
    
    func sendEmailVerification(completion: @escaping AuthenticationOperation) {
        if (self.user != nil) {
            completion(AuthenticationError.notLoggedIn)
        } else {
            self.user = AuthenticationUser(
                id: self.user!.id,
                email: self.user!.email,
                verified: true
            )
            completion(nil)
        }
    }
    
    func sendPasswordReset(to email: String, completion: @escaping AuthenticationOperation) {
        if (self.user != nil) {
            completion(AuthenticationError.notLoggedIn)
        } else {
            completion(nil)
        }
    }
    
    func updateEmail(to email: String, completion: @escaping AuthenticationOperation) {
        if (self.user != nil) {
            completion(AuthenticationError.notLoggedIn)
        } else {
            self.user = AuthenticationUser(
                id: self.user!.id,
                email: email,
                verified: self.user!.verified
            )
            completion(nil)
        }
    }
    
}

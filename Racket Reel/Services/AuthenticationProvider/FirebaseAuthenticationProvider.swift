//
//  FirebaseAuthenticationProvider.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation
import Firebase
import FirebaseAuth

public class FirebaseAuthenticationProvider: AuthenticationProvider {
    
    public var user: AuthenticationUser? {
        didSet {
            for observer in userObservers {
                observer(self.user)
            }
        }
    }
    
    public var userObservers: [AuthenticationUserUpdate] = []
    
    private let auth = Auth.auth()
    
    init() {
        // Listen for changes to the FirebaseAuth.User and update user accordingly.
        self.auth.addStateDidChangeListener({ auth, user in
            if (user != nil && user?.email != nil) {
                self.user = AuthenticationUser(
                    id: user!.uid,
                    email: user!.email!,
                    verified: user!.isEmailVerified
                )
            } else {
                self.user = nil
            }
        })
    }
    
    public func addUserObserver(_ handler: @escaping AuthenticationUserUpdate) {
        userObservers.append(handler)
        // Initial execution
        handler(self.user)
    }
    
    public func logIn(email: String, password: String, completion: @escaping AuthenticationOperation) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
    
    public func logOut(completion: @escaping AuthenticationOperation) {
        do {
            try auth.signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    public func register(email: String, password: String, completion: @escaping AuthenticationOperation) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
    
    public func sendEmailVerification(completion: @escaping AuthenticationOperation) {
        if (auth.currentUser != nil) {
            auth.currentUser!.sendEmailVerification(completion: completion)
        } else {
            completion(AuthenticationError.notLoggedIn)
        }
    }
    
    public func sendPasswordReset(to email: String, completion: @escaping AuthenticationOperation) {
        auth.sendPasswordReset(withEmail: email, completion: completion)
    }
    
    public func updateEmail(to email: String, completion: @escaping AuthenticationOperation) {
        if (auth.currentUser != nil) {
            auth.currentUser!.updateEmail(to: email, completion: completion)
        } else {
            completion(AuthenticationError.notLoggedIn)
        }
    }
    
}

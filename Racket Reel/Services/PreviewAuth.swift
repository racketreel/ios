//
//  PreviewAuth.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 03/10/2021.
//

import Foundation

class PreviewAuth: AuthProtocol {
    
    var userObservers: [UserUpdate] = []
    
    var user: User? {
        didSet {
            // Notify all observers that user changes
            for observer in userObservers {
                observer(self.user)
            }
        }
    }
    
    func logIn(email: String, password: String, completion: @escaping AuthTaskCompletion) {
        // Set to hardcoded user
        self.user = User(uid: UUID().uuidString.lowercased(), firstname: "Tom", surname: "Elvidge", email: email, verifiedEmail: true)
        
        // No error
        completion(nil)
    }
    
    func logOut(completion: @escaping AuthTaskCompletion) {
        // Set user to nil
        self.user = nil
        
        // No error
        completion(nil)
    }
    
    func register(email: String, password: String, confirmPassword: String, firstname: String, surname: String, completion: @escaping AuthTaskCompletion) {
        // New user
        self.user = User(uid: UUID().uuidString.lowercased(), firstname: firstname, surname: surname, email: email, verifiedEmail: false)
        
        // No error
        completion(nil)
    }
    
    func sendEmailVerification(completion: @escaping AuthTaskCompletion) {
        // Update verification status
        self.user?.verifiedEmail = true
        
        // No error
        completion(nil)
    }
    
    func sendPasswordReset(email: String, completion: @escaping AuthTaskCompletion) {
        // No error
        completion(nil)
    }
    
    func updateEmail(to: String, completion: @escaping AuthTaskCompletion) {
        // Update email
        self.user?.email = to
        
        // No error
        completion( nil)
    }
    
    func updateUserData(firstname: String, surname: String, completion: @escaping AuthTaskCompletion) {
        // Update user data
        self.user?.firstname = firstname
        self.user?.surname = surname
        
        // No error
        completion(nil)
    }
    
}

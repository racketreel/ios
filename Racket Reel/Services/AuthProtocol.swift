//
//  AuthServiceProtocol.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 03/10/2021.
//

import Foundation

protocol AuthProtocol {
    
    typealias AuthTaskCompletion = (_ error: Error?) -> Void
    typealias UserUpdate = (_ user: User?) -> Void
    
    var user: User? { get }
    
    var userObservers: [UserUpdate] { get set }
    
    func logIn(email: String, password: String, completion: @escaping AuthTaskCompletion)
    
    func logOut(completion: @escaping AuthTaskCompletion)
    
    func register(email: String, password: String, firstname: String, surname: String, completion: @escaping AuthTaskCompletion)
    
    func sendEmailVerification(completion: @escaping AuthTaskCompletion)
    
    func sendPasswordReset(email: String, completion: @escaping AuthTaskCompletion)
    
    func updateEmail(to: String, completion: @escaping AuthTaskCompletion)
    
    func updateUserData(firstname: String, surname: String, completion: @escaping AuthTaskCompletion)
    
}

extension AuthProtocol {
    
    mutating func addUserObserver(_ userUpdateHandler: @escaping UserUpdate) {
        userObservers.append(userUpdateHandler)
    }
    
}

public enum AuthError: Error {
    case notSignedIn
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notSignedIn:
            return NSLocalizedString("There is no user currently signed in.", comment: "Not Signed In")
        }
    }
}

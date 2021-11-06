//
//  AuthenticationProvider.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation

public protocol AuthenticationProvider {
    
    typealias AuthenticationOperation = (_ error: Error?) -> Void
    typealias AuthenticationUserUpdate = (_ user: AuthenticationUser?) -> Void
    
    var user: AuthenticationUser? { get }
    
    var userObservers: [AuthenticationUserUpdate] { get }
    
    func addUserObserver(_ handler: @escaping AuthenticationUserUpdate)
    
    func logIn(email: String, password: String, completion: @escaping AuthenticationOperation)
    
    func logOut(completion: @escaping AuthenticationOperation)
    
    func register(email: String, password: String, completion: @escaping AuthenticationOperation)
    
    func sendEmailVerification(completion: @escaping AuthenticationOperation)
    
    func sendPasswordReset(to email: String, completion: @escaping AuthenticationOperation)
    
    func updateEmail(to email: String, completion: @escaping AuthenticationOperation)
    
}

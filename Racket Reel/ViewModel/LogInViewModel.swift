//
//  SignInViewModel.swift
//  RacketReel
//
//  Created by Tom Elvidge on 09/10/2021.
//

import Foundation

class LogInViewModel: ObservableObject {
    
    // View's text fields
    @Published var email = ""
    @Published var password = ""
    
    @Published var showLoggingInSpinner = false
    @Published var showLogInFailedAlert = false
    @Published var showSentPasswordResetEmailAlert = false
    
    var auth: AuthProtocol
    
    init(auth: AuthProtocol) {
        self.auth = auth
    }
    
    func logIn() {
        // Show spinner while attempting to sign in
        self.showLoggingInSpinner = true
        
        auth.logIn(email: self.email, password: self.password, completion: { error in
            // Completed attempting to sign in
            self.showLoggingInSpinner = false
            
            // If failed to sign in then show alert and log error
            if (error != nil) {
                self.showLogInFailedAlert = true
                print(error!.localizedDescription)
            }
        })
    }
    
    func forgotPassword() {
        auth.sendPasswordReset(email: self.email, completion: { error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                self.showSentPasswordResetEmailAlert = true
            }
        })
    }
    
}

//
//  SignUpViewModel.swift
//  RacketReel
//
//  Created by Tom Elvidge on 09/10/2021.
//

import Foundation

class RegisterViewModel: ObservableObject {
    
    @Published var firstname = ""
    @Published var surname = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var showRegisteringSpinner = false
    @Published var showRegisterFailedAlert = false
    @Published var registerFailedAlertMessage = ""
    
    private var auth: AuthProtocol
    
    init(auth: AuthProtocol) {
        self.auth = auth
    }
    
    func register() {
        // Todo: Validate fields
        // Email taken?
        
        // Show spinner while attempting to sign up
        self.showRegisteringSpinner = true
        
        auth.register(email: self.email, password: self.password, confirmPassword: self.confirmPassword, firstname: self.firstname, surname: self.surname, completion: { error in
            // Completed attempting to register
            self.showRegisteringSpinner = false
            
            // If failed to register then show alert and show error
            if (error != nil) {
                self.showRegisterFailedAlert = true
                self.registerFailedAlertMessage = error!.localizedDescription
            }
        })
    }
    
}

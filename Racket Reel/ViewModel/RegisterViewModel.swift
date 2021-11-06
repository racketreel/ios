//
//  SignUpViewModel.swift
//  RacketReel
//
//  Created by Tom Elvidge on 09/10/2021.
//

import Foundation
import CoreMedia

class RegisterViewModel: ObservableObject {
    
    @Published var firstname = ""
    @Published var surname = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var showRegisteringSpinner = false
    @Published var showRegisterFailedAlert = false
    @Published var registerFailedAlertMessage = ""
    
    @Inject var auth: AuthenticationProvider
    @Inject var userInfo: AnyDataProvider<UserInfo>
    
    func register() {
        // Ensure fields are valid before attempting to register
        do {
            try validate()
        } catch {
            self.showRegisterFailedAlert = true
            self.registerFailedAlertMessage = error.localizedDescription
            return
        }
        
        // Show spinner while attempting to register
        self.showRegisteringSpinner = true
        
        auth.register(email: self.email, password: self.password, completion: { error in
            // If failed to register then stop spinner and show alert with error message
            if (error != nil) {
                self.showRegisteringSpinner = false
                self.showRegisterFailedAlert = true
                self.registerFailedAlertMessage = error!.localizedDescription
                return
            }
            
            // If registered and now logged in then create user's info
            if (self.auth.user != nil) {
                self.userInfo.create(
                    UserInfo(
                        id: self.auth.user!.id,
                        firstname: self.firstname,
                        surname: self.surname,
                        matchIds: []
                    ),
                    completion: { error in
                        if (error != nil) {
                            print(error!.localizedDescription)
                        }
                    }
                )
            }
            
            // Completed attempting to register
            self.showRegisteringSpinner = false
        })
    }
    
    func validate() throws {
        if (password != confirmPassword) {
            throw RegistrationError.passwordDoesNotMatch
        }
        
        if (firstname.isEmpty) {
            throw RegistrationError.emptyFirstname
        }
        
        if (surname.isEmpty) {
            throw RegistrationError.emptySurname
        }
    }
    
}

public enum RegistrationError: Error {
    case passwordDoesNotMatch
    case emptyFirstname
    case emptySurname
}

extension RegistrationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .passwordDoesNotMatch:
                return NSLocalizedString("The passwords do not match.", comment: "Passwords Does Not Match")
            case .emptyFirstname:
                return NSLocalizedString("Firstname cannot be empty.", comment: "Empty Firstname")
            case .emptySurname:
                return NSLocalizedString("Surname cannot be empty.", comment: "Empty Surname")
        }
    }
}

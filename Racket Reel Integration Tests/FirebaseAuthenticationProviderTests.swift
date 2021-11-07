//
//  FirebaseAuthenticationProviderTests.swift
//  Racket Reel Integration Tests
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation
@testable import Racket_Reel
import XCTest

class FirebaseAuthenticationProviderTests: XCTestCase {
    
    var auth = FirebaseAuthenticationProvider()
    
    let emailDomain = "@racketreel.com"
    let password = "password"
    
    func testRegistration() {
        // Arrange
        let expectedEmail = UUID().uuidString.lowercased() + emailDomain
        var actualError: Error?
        
        // Act
        let expectation = self.expectation(description: "Registering")
        auth.register(email: expectedEmail, password: self.password, completion: { error in
            actualError = error
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssert(actualError == nil, "There should be no error when registering")
        XCTAssert(auth.user != nil, "A user should be logged in after successful registration")
        XCTAssert(expectedEmail == auth.user?.email, "The user registered with the email \(expectedEmail) but the logged in user has the email \(auth.user?.email ?? "nil").")
    }
    
    func testLogIn() {
        // Arrange
        let expectedEmail = "test" + emailDomain
        var actualError: Error?
        
        // Register incase the user does not yet exist
        let registeringExpecation = self.expectation(description: "Registering")
        auth.register(email: expectedEmail, password: self.password, completion: { error in
            registeringExpecation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        // Act
        let loggingInExpectation = self.expectation(description: "Logging In")
        auth.logIn(email: expectedEmail, password: self.password, completion: { error in
            actualError = error
            loggingInExpectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssert(actualError == nil, "There should be no error when logging in")
        XCTAssert(auth.user != nil, "A user should be logged in after successful log in")
        XCTAssert(expectedEmail == auth.user?.email, "The user logged in with the email \(expectedEmail) but the logged in user actually has the email \(auth.user?.email ?? "nil").")
    }

}

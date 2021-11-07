//
//  FirestoreDataProviderTests.swift
//  Racket Reel Integration Tests
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation
@testable import Racket_Reel
import XCTest

class FirestoreDataProviderTests: XCTestCase {
    
    var auth = FirebaseAuthenticationProvider()
    var userInfo = FirestoreDataProvider<UserInfo>(path: "userInfo")
    
    func testCreateAndReadUserInfo() {
        // Register a test user
        let email = UUID().uuidString.lowercased() + "@racketreel.com"
        let registering = self.expectation(description: "Registering")
        auth.register(email: email, password: "password", completion: { error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            registering.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        // Arrange
        let expectedUserInfo = UserInfo(
            id: self.auth.user!.id,
            firstname: "Racket",
            surname: "Reel",
            matchIds: []
        )
        var actualUserInfo: UserInfo?
        var actualCreateError: Error?
        var actualReadError: Error?
        
        // Act Create
        let creatingUserInfo = self.expectation(description: "Creating UserInfo")
        self.userInfo.create(expectedUserInfo, completion: { error in
            actualCreateError = error
            creatingUserInfo.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert Create
        XCTAssert(actualCreateError == nil, "There should be no error when creating the UserInfo")
        
        // Act Read
        let readingUserInfo = self.expectation(description: "Reading UserInfo")
        self.userInfo.read(id: self.auth.user!.id, completion: { error, userInfo in
            actualReadError = error
            actualUserInfo = userInfo
            readingUserInfo.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert Read
        XCTAssert(actualReadError == nil, "There should be no error when reading the UserInfo")
        XCTAssert(expectedUserInfo.firstname == actualUserInfo?.firstname, "There actual firstname was \(actualUserInfo?.firstname ?? "nil") when it was expected to be \(expectedUserInfo.firstname)")
        XCTAssert(expectedUserInfo.surname == actualUserInfo?.surname, "There actual surname was \(actualUserInfo?.surname ?? "nil") when it was expected to be \(expectedUserInfo.surname)")
        XCTAssert(expectedUserInfo.matchIds == actualUserInfo?.matchIds, "There actual matchIds was \(actualUserInfo!.matchIds) when it was expected to be \(expectedUserInfo.matchIds)")
    }
    
}

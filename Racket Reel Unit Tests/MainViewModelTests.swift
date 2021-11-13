//
//  MainViewModelTests.swift
//  Racket Reel Unit Tests
//
//  Created by Tom Elvidge on 07/11/2021.
//

import Foundation
import XCTest
@testable import Racket_Reel

class MainViewModelTests: XCTestCase {

    class override func setUp() {
        Resolver.shared.setContainer(PreviewContainer.build())
    }
    
    func testExample()  {
        let mainViewModel = MainViewModel()
    }

}


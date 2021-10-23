//
//  Resolver.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 23/10/2021.
//

import Foundation
import Swinject

class Resolver {
    
    static let shared = Resolver()
    private var container = MainContainer.build()
    
    func resolve<T>(_ type: T.Type) -> T {
        self.container.resolve(T.self)!
    }
    
    func setContainer(_ container: Container) {
        self.container = container
    }
    
}

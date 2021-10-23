//
//  InjectPropertyWrapper.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 23/10/2021.
//

import Foundation

@propertyWrapper
struct Inject<Component> {
    var wrappedValue: Component
    init() {
        self.wrappedValue = Resolver.shared.resolve(Component.self)
    }
}

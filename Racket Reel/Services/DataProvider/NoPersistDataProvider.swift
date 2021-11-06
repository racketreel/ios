//
//  NoPersistDataProvider.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation

class NoPersistDataProvider<T: Identifiable>: DataProvider where T.ID == String {
    
    typealias DataType = T
    
    var store: [String: T]
    
    init(store: [String: T]) {
        self.store = store
    }
    
    func create(_ document: T, completion: @escaping DataProviderBasicOperation) {
        self.store[document.id] = document
        completion(nil)
    }
    
    func read(id: String, completion: @escaping DataProviderReadOperation) {
        if let document = self.store[id] {
            completion(nil, document)
        } else {
            completion(NoPersistDataProvider.notFound, nil)
        }
    }
    
    func update(id: String, with: T, completion: @escaping DataProviderBasicOperation) {
        if (self.store[id] != nil) {
            // Override if exists.
            self.store[id] = with
            completion(nil)
        } else {
            completion(NoPersistDataProvider.notFound)
        }
    }
    
    func delete(id: String, completion: @escaping DataProviderBasicOperation) {
        if (self.store[id] != nil) {
            // Delete if exists
            self.store.removeValue(forKey: id)
        } else {
            completion(NoPersistDataProvider.notFound)
        }
    }
    
    enum NoPersistDataProvider: Error {
        case notFound
    }
    
}

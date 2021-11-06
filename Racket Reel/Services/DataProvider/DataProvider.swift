//
//  DataProvider.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation

protocol DataProvider {
    
    associatedtype DataType
    
    typealias DataProviderBasicOperation = (_ error: Error?) -> Void
    typealias DataProviderReadOperation = (_ error: Error?, _ data: DataType?) -> Void
    
    func create(_ data: DataType, completion: @escaping DataProviderBasicOperation)
    
    func read(id: String, completion: @escaping DataProviderReadOperation)

    func update(id: String, with data: DataType, completion: @escaping DataProviderBasicOperation)

    func delete(id: String, completion: @escaping DataProviderBasicOperation)
    
}

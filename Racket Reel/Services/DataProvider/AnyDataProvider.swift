//
//  AnyDataProvider.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//
//  Type erasure method to create generic data provider.
//

import Foundation

class AnyDataProvider<DataType>: DataProvider {
    
    // Have to create copy: "Reference to invalid type alias 'CRUDReadOperation' of type 'AnyCRUDConnector<DocumentType>'"
    typealias DataProviderReadOperationCopy = (_ error: Error?, _ data: DataType?) -> Void
 
    private let _create: (DataType, @escaping DataProviderBasicOperation) -> Void
    private let _read: (String, @escaping DataProviderReadOperation) -> Void
    private let _update: (String, DataType, @escaping DataProviderBasicOperation) -> Void
    private let _delete: (String, @escaping DataProviderBasicOperation) -> Void
    
    init<Connector: DataProvider>(wrappedConnector: Connector) where Connector.DataType == DataType {
        self._create = wrappedConnector.create
        self._read = wrappedConnector.read
        self._update = wrappedConnector.update
        self._delete = wrappedConnector.delete
    }
    
    func create(_ data: DataType, completion: @escaping DataProviderBasicOperation) {
        self._create(data, completion)
    }
    
    func read(id: String, completion: @escaping DataProviderReadOperationCopy) {
        self._read(id, completion)
    }
    
    func update(id: String, with data: DataType, completion: @escaping DataProviderBasicOperation) {
        self._update(id, data, completion)
    }
    
    func delete(id: String, completion: @escaping DataProviderBasicOperation) {
        self._delete(id, completion)
    }

}

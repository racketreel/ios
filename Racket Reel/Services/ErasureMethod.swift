//
//  ErasureMethod.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

protocol CRUDConnector {
    
    associatedtype DocumentType
    
    typealias CRUDOperation = (_ error: Error?) -> Void
    typealias CRUDReadOperation = (_ error: Error?, _ document: DocumentType?) -> Void
    
    func create(_ document: DocumentType, completion: @escaping CRUDOperation)
    
    func read(id: String, completion: @escaping CRUDReadOperation)

    func update(id: String, with: DocumentType, completion: @escaping CRUDOperation)

    func delete(id: String, completion: @escaping CRUDOperation)
    
}

// Type-erasure
class AnyCRUDConnector<DocumentType>: CRUDConnector {
 
    private let _create: (DocumentType, @escaping CRUDOperation) -> Void
    private let _read: (String, @escaping CRUDReadOperation) -> Void
    private let _update: (String, DocumentType, @escaping CRUDOperation) -> Void
    private let _delete: (String, @escaping CRUDOperation) -> Void
    
    init<Connector: CRUDConnector>(wrappedConnector: Connector) where Connector.DocumentType == DocumentType {
        self._create = wrappedConnector.create
        self._read = wrappedConnector.read
        self._update = wrappedConnector.update
        self._delete = wrappedConnector.delete
    }
    
    func create(_ document: DocumentType, completion: @escaping CRUDOperation) {
        self._create(document, completion)
    }
    
    func read(id: String, completion: @escaping CRUDReadOperation) {
        self._read(id, completion)
    }
    
    func update(id: String, with: DocumentType, completion: @escaping CRUDOperation) {
        self._update(id, with, completion)
    }
    
    func delete(id: String, completion: @escaping CRUDOperation) {
        self._delete(id, completion)
    }

}

// DocumentType (T) must be Indetifiable and Codable with a String ID for use in Firestore.
class FirestoreCRUDConnector<T: Identifiable>: CRUDConnector where T.ID == String, T: Codable {
    
    typealias DocumentType = T
    
    private var collection: CollectionReference

    init(path: String) {
        self.collection = Firestore.firestore().collection(path)
    }
    
    func create(_ document: T, completion: @escaping CRUDOperation) {
        self.update(id: document.id, with: document, completion: completion)
    }
    
    func read(id: String, completion: @escaping CRUDReadOperation) {
        let reference = collection.document(id)
        reference.getDocument { rawDocument, error in
            if let error = error {
                completion(error, nil)
            } else {
                if let rawDocument = rawDocument {
                    do {
                        let document = try rawDocument.data(as: T.self)
                        completion(nil, document)
                    } catch {
                        completion(error, nil)
                    }
                } else {
                    // Custom error, rawDocument is nil.
                    completion(nil, nil)
                }
            }
        }
    }
    
    func update(id: String, with: T, completion: @escaping CRUDOperation) {
        let reference = collection.document(id)
        do {
            try reference.setData(from: with)
            completion(nil)
        }
        catch {
            completion(error)
        }
    }
    
    func delete(id: String, completion: @escaping CRUDOperation) {
        collection.document(id).delete() { error in
            completion(error)
        }
    }
    
}

class PreviewUserInfo: CRUDConnector {
    
    typealias DocumentType = UserInfo
    
    private var store: [String: UserInfo] = [:]
    
    init() {
        // Create a test user and add to the store.
        let testUser = UserInfo(
            id: UUID.init().uuidString,
            firstname: "Tom",
            surname: "Elvidge",
            matchIds: []
        )
        self.store[testUser.id] = testUser
    }
    
    func create(_ document: UserInfo, completion: @escaping CRUDOperation) {
        self.store[document.id] = document
        completion(nil)
    }
    
    func read(id: String, completion: @escaping CRUDReadOperation) {
        if let document = self.store[id] {
            completion(nil, document)
        } else {
            completion(PreviewUserInfoError.notFound, nil)
        }
    }
    
    func update(id: String, with: UserInfo, completion: @escaping CRUDOperation) {
        if (self.store[id] != nil) {
            // Override if exists.
            self.store[id] = with
            completion(nil)
        } else {
            completion(PreviewUserInfoError.notFound)
        }
    }
    
    func delete(id: String, completion: @escaping CRUDOperation) {
        if (self.store[id] != nil) {
            // Delete if exists
            self.store.removeValue(forKey: id)
        } else {
            completion(PreviewUserInfoError.notFound)
        }
    }
    
    enum PreviewUserInfoError: Error {
        case notFound
    }
    
}

struct UserInfo: Identifiable, Codable {
    let id: String
    var firstname: String
    var surname: String
    var matchIds: [String]
}

class Demo {
    
    var connector: AnyCRUDConnector<UserInfo>
    
    init(connector: AnyCRUDConnector<UserInfo>) {
        self.connector = connector
    }
    
}

class Injector {
    
    var demo = Demo(connector: AnyCRUDConnector(wrappedConnector: FirestoreCRUDConnector<UserInfo>(path: "userInfo")))
    var demoPreview = Demo(connector: AnyCRUDConnector(wrappedConnector: PreviewUserInfo()))
    
}

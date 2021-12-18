//
//  FirestoreDataProvider.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

// DataType, T, must be Identifiable and Codable with a String ID for use in Firestore.
// This class assumes Firebase has already been configured.
class FirestoreDataProvider<T: Identifiable>: DataProvider where T.ID == String, T: Codable {
    
    typealias DataType = T
    
    private var collection: CollectionReference
    
    private let cache = Cache<T.ID, T>()

    init(path: String) {
        self.collection = Firestore.firestore().collection(path)
    }
    
    func create(_ data: T, completion: @escaping DataProviderBasicOperation) {
        self.update(id: data.id, with: data, completion: completion)
    }
    
    func read(id: String, completion: @escaping DataProviderReadOperation) {
        // Check if in cache first
        if let cached = cache[id] {
            return completion(nil, cached)
        }
        
        let reference = collection.document(id)
        reference.getDocument { rawDocument, error in
            if let error = error {
                completion(error, nil)
            } else {
                if let rawDocument = rawDocument {
                    do {
                        let document = try rawDocument.data(as: T.self)
                        document.map { self.cache[id] = $0 }
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
    
    func update(id: String, with data: T, completion: @escaping DataProviderBasicOperation) {
        
        let reference = collection.document(id)
        do {
            try reference.setData(from: data)
            // Invalidate the cache so the new data gets pulled
            self.cache.removeValue(forKey: id)
            completion(nil)
        }
        catch {
            completion(error)
        }
    }
    
    func delete(id: String, completion: @escaping DataProviderBasicOperation) {
        collection.document(id).delete() { error in
            completion(error)
        }
    }
    
}

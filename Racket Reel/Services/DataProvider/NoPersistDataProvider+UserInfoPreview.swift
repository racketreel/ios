//
//  NoPersistDataProvider+UserInfoPreview.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation

extension NoPersistDataProvider where T == UserInfo {
    
    convenience init() {
        // Create a test user.
        let testUser = UserInfo(
            id: "1",
            firstname: "Tom",
            surname: "Elvidge",
            matchIds: []
        )
        
        self.init(store: [testUser.id: testUser])
    }
    
}

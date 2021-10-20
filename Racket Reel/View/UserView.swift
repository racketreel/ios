//
//  UserView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 20/10/2021.
//

import SwiftUI

struct UserView: View {
    
    private var auth: AuthProtocol
    
    init(auth: AuthProtocol) {
        self.auth = auth
    }
    
    var body: some View {
        // Temp log out button
        Button("Log Out") {
            auth.logOut(completion: { error in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(auth: PreviewAuth())
    }
}

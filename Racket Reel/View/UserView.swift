//
//  UserView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 20/10/2021.
//

import SwiftUI

struct UserView: View {
    
    @ObservedObject var viewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Custom background color.
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    // Temp log out button
                    Button("Log Out") {
                        viewModel.logOut()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("User")
                }
            }
        }
    }
    
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.shared.setContainer(PreviewContainer.build())
        return UserView()
    }
}

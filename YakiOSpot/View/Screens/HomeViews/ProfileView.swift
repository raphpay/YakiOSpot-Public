//
//  ProfileView.swift
//  YakiOSpot
//
//  Created by Raphaël Payet on 15/11/2021.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isConnected: Bool
    @State var displayName: String = ""
    
    var body: some View {
        VStack {
            Text("Hello, \(displayName)!")
            Button {
                didTapLogOut()
            } label: {
                Text("Se déconnecter")
            }
        }
        .onAppear {
            print("isConnected :", UserDefaults.standard.bool(forKey: DefaultKeys.IS_USER_CONNECTED))
        }
    }
    
    func didTapLogOut() {
        API.Auth.session.signOut {
            isConnected = false
        } onError: { error in
            isConnected = true
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isConnected: .constant(true), displayName: "World")
    }
}

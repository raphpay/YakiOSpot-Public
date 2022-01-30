//
//  ProfileView.swift
//  YakiOSpot
//
//  Created by Raphaël Payet on 15/11/2021.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewViewModel()
    @Binding var isConnected: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileRow(user: $viewModel.user)
                
                ProfileSection {
                    HStack {
                        StatusButton(isSelected: $viewModel.userIsPresent, title: "🚵‍♂️ Au spot", color: .green) {
                            viewModel.didTapHereButton()
                        }
                        Spacer()
                        StatusButton(isSelected: $viewModel.userIsNotPresent, title: "🚶‍♂️ Plus au spot", color: .red) {
                            viewModel.didTapLeavingButton()
                        }
                    }
                    .padding(.horizontal)
                }
                
                ProfileSection(title: "Mes sessions") {
                    SessionRow(sessions: $viewModel.sessions)
                } action: {
                    print("Hello world")
                }
                
                
                ProfileSection(title: "Mon bike") {
                    BikeRow()
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Profil")
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(viewModel.agreeButtonText) {
                viewModel.toggleUserPresence()
            }
            Button(viewModel.cancelButtonText) {}
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

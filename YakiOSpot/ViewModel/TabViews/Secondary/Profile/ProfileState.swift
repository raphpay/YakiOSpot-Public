//
//  ProfileViewViewModel.swift
//  YakiOSpot
//
//  Created by Raphaël Payet on 29/01/2022.
//

import Foundation

final class ProfileState: ObservableObject {
    // User object
    @Published var user: User = MockUser.data
    @Published var bike: Bike = Bike(id: UUID().uuidString, model: "", photoURL: nil)
    
    // Properties
    @Published var userIsPresent: Bool = true
    @Published var userIsNotPresent: Bool = false
    @Published var sessions: [Session] = []
    
    // Images
    @Published var bikeImageData = Data()
    
    // Alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var agreeButtonText: String = ""
    @Published var cancelButtonText: String = ""
    @Published var buttonSelected: Int = 0
    
    // Navigation
    @Published var showSessionCreation: Bool = false
    @Published var showBikeCreation: Bool = false
    
    init() {
        fetchData()
    }
}

// MARK: - Initialisation
extension ProfileState {
    func fetchData() {
        guard let currentUser = API.User.CURRENT_USER_OBJECT else { return }
        API.User.session.getUserFromUID(currentUser.id) { user in
            print("======= \(#function) =====", user)
            self.user = user
            if let bike = user.bike {
                self.bike = bike
                self.downloadBikeImageData()
            }
            if let userPresence = user.isPresent {
                self.userIsPresent = userPresence
            } else {
                self.userIsPresent = false
            }
            self.updateSessions(user.sessions)
        } onError: { error in
            print("======= \(#function) =====", error)
            self.userIsPresent = false
        }
    }
    
    func downloadBikeImageData() {
        StorageService.shared.downloadBikeImageForCurrentUser { imageData in
            print("======= \(#function) =====", imageData)
            self.bikeImageData = imageData
        } onError: { error in
            print("======= \(#function) downloadBikeImageForCurrentUser =====", error)
        }
    }
}

// MARK: - Actions
extension ProfileState {
    func didTapHereButton() {
        showAlert.toggle()
        alertTitle = "Tu es au spot ?"
        agreeButtonText = "Oui, je suis là !"
        cancelButtonText = "Non, je ne suis pas là"
    }
    
    func didTapLeavingButton() {
        showAlert.toggle()
        alertTitle = "Tu pars déjà ?"
        agreeButtonText = "Oui, je pars !"
        cancelButtonText = "Je suis toujours là"
    }
    
    func confirmAlert() {
        if userIsPresent {
            setUserAbsent()
        } else {
            setUserPresent()
        }
    }
    
    func setUserPresent() {
        API.User.session.setUserPresence { user in
            API.Spot.session.setUserPresent() {
                self.userIsPresent = true
                self.sendPresenceNotification(from: user.pseudo)
            } onError: { error in
                print("======= \(#function) setUserPresent=====", error)
            }
        } onError: { error in
            print("======= \(#function) setUserPresence =====", error)
        }
    }
    
    func setUserAbsent() {
        API.User.session.setUserAbsence { user in
            API.Spot.session.removeUsersFromSpot([user]) {
                self.userIsPresent = false
            } onError: { error in
                print("======= \(#function) removeUsersFromSpot =====", error)
            }
        } onError: { error in
            print("======= \(#function) setUserAbsence =====", error)
        }
    }

    func updateMembership(isMember: Bool, memberType: User.MemberType) {
        self.user.isMember = isMember
        self.user.memberType = memberType
    }
}

// MARK: - Private Method
extension ProfileState {
    private func updateSessions(_ array: [String]?) {
        if let sessionIDs = array,
           !sessionIDs.isEmpty {
            API.Session.session.fetchSessionsForIDs(sessionIDs) { sessions in
                self.sessions = sessions
            } onError: { error in
                self.sessions = []
            }

        } else {
            sessions = []
        }
    }
    
    private func sendPresenceNotification(from pseudo: String) {
        API.Token.session.getAllTokens { tokens in
            for token in tokens {
                PushNotificationSender.shared.sendPresenceNotification(to: token, from: pseudo)
            }
        } onError: { error in
            print("getAllTokens error", error)
        }
    }
}

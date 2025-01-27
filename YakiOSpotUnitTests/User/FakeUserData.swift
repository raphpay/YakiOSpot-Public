//
//  FakeUserData.swift
//  YakiOSpotUnitTests
//
//  Created by Raphaël Payet on 10/12/2021.
//

import Foundation
@testable import YakiOSpot

final class FakeUserData {
    // MARK: - ID
    static let correctID    = "correctID"
    static let correctNewId = "correctNewID"
    static let incorrectID  = ""
    
    
    // MARK: - Pseudo
    static let correctPseudo    = "Tester"
    static let correctNewPseudo = "NewTester"
    
    
    // MARK: - Mail
    static let correctMail      = "test@test.com"
    static let correctNewMail   = "newtest@test.com"
    
    
    // MARK: - User
    static let correctUser      = User(id: correctID, pseudo: correctPseudo, mail: correctMail, favoritedSpotsIDs: nil)
    static let presentUser      = User(id: correctID, pseudo: correctPseudo, mail: correctMail, favoritedSpotsIDs: nil, isPresent: true)
    static let correctNewUser   = User(id: correctNewId, pseudo: correctNewPseudo, mail: correctNewMail, favoritedSpotsIDs: nil)
    static let incorrectUser    = User(id: incorrectID, pseudo: correctPseudo, mail: correctMail, favoritedSpotsIDs: nil)
    static let oneSessionUser   = User(id: correctID, pseudo: correctPseudo, mail: correctMail, favoritedSpotsIDs: nil, sessions: ["Session1"])
    static var mutableUser      = correctUser
    
    // MARK: - Users
    static let referenceUsers = [correctUser]
    static var mutableUsers = referenceUsers
    
    // MARK: - Sessions
    static let sessions = [Session(id: "Session1", creator: correctUser, date: Date.now)]
    
    // MARK: - Dates
    static let correctDate = Date(timeIntervalSince1970: 0)
    
    
    // MARK: - Errors
    static let noUserError = "Can't find this user"
    static let noSessionError = "No sessions"
    static let postError = "Can't add user in local database"
    static let adPostError = "Can't add ad to user in local database"
    static let incorrectUserError = "Incorrect user"
}

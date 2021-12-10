//
//  UserServiceTestsCase.swift
//  YakiOSpotUnitTests
//
//  Created by Raphaël Payet on 10/12/2021.
//

import XCTest
@testable import YakiOSpot

class UserServiceTestsCase: XCTestCase {

    var session: UserEngine?
    var service: UserEngineService?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        session = FakeUserService.shared
        service = UserEngineService(session: session!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        session = nil
        service = nil
        FakeUserData.mutableUsers = FakeUserData.referenceUsers
    }
}


// MARK: - Post
extension UserServiceTestsCase {
    func testGivenUserIsCorrect_WhenAddingToDatabase_ThenOnSuccessIsCalled() {
        let expectation = XCTestExpectation(description: "Success when adding correct user to database")
        
        service?.session.addUserToDatabase(FakeUserData.correctNewUser, onSuccess: {
            XCTAssertEqual(FakeUserData.mutableUsers.count, FakeUserData.referenceUsers.count + 1)
            XCTAssertEqual(FakeUserData.mutableUsers.last?.id, FakeUserData.correctNewUser.id)
            expectation.fulfill()
        }, onError: { _ in
            //
        })
        
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenUserIsIncorrect_WhenAddingToDatabase_ThenOnErrorIsCalled() {
        let expectation = XCTestExpectation(description: "Error when adding incorrect user to database")
        
        service?.session.addUserToDatabase(FakeUserData.incorrectUser, onSuccess: {
            //
        }, onError: { error in
            XCTAssertEqual(error, FakeUserData.postError)
            expectation.fulfill()
        })
        
        
        wait(for: [expectation], timeout: 0.01)
    }
}


// MARK: - Fetch
extension UserServiceTestsCase {
    func testGivenUserExists_WhenGettingUserPseudo_ThenOnSuccessIsCalled() {
        let expectation = XCTestExpectation(description: "Success when getting correct user pseudo")
        
        service?.session.getUserPseudo(with: FakeUserData.correctID, onSuccess: { pseudo in
            XCTAssertEqual(pseudo, FakeUserData.correctPseudo)
            expectation.fulfill()
        }, onError: { _ in
            //
        })
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGivenUserDoesNotExists_WhenGettingUserPseudo_ThenOnErrorIsCalled() {
        let expectation = XCTestExpectation(description: "Error when getting incorrect user pseudo")
        
        service?.session.getUserPseudo(with: FakeUserData.incorrectID, onSuccess: { _ in
            //
        }, onError: { error in
            XCTAssertEqual(error, FakeUserData.noUserError)
            expectation.fulfill()
        })
        
        
        wait(for: [expectation], timeout: 0.01)
    }
}
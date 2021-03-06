//
//  UserAPITests.swift
//  SwaggerClient
//
//  Created by Robin Eggenkamp on 5/21/16.
//  Copyright © 2016 Swagger. All rights reserved.
//

import PetstoreClient
import XCTest
@testable import SwaggerClient

class UserAPITests: XCTestCase {
    
    let testTimeout = 10.0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        let expectation = self.expectation(description: "testLogin")
        
        UserAPI.loginUser(username: "swiftTester", password: "swift") { (_, error) in
            guard error == nil else {
                XCTFail("error logging in")
                return
            }

            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: testTimeout, handler: nil)
    }
    
    func testLogout() {
        let expectation = self.expectation(description: "testLogout")
        
        UserAPI.logoutUser { (error) in
            guard error == nil else {
                XCTFail("error logging out")
                return
            }

            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: testTimeout, handler: nil)
    }
    
    func test1CreateUser() {
        let expectation = self.expectation(description: "testCreateUser")
        
        let newUser = User()
        newUser.email = "test@test.com"
        newUser.firstName = "Test"
        newUser.lastName = "Tester"
        newUser.id = 1000
        newUser.password = "test!"
        newUser.phone = "867-5309"
        newUser.username = "test@test.com"
        newUser.userStatus = 0
        
        UserAPI.createUser(body: newUser) { (error) in
            guard error == nil else {
                XCTFail("error creating user")
                return
            }

            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: testTimeout, handler: nil)
    }
    
    func testCreateUserWithArray() {
        let expectation = self.expectation(description: "testCreateUserWithArray")
        let newUser = User()
        newUser.email = "test@test.com"
        newUser.firstName = "Test"
        newUser.lastName = "Tester"
        newUser.id = 1000
        newUser.password = "test!"
        newUser.phone = "867-5309"
        newUser.username = "test@test.com"
        newUser.userStatus = 0
        
        let newUser2 = User()
        newUser2.email = "test2@test.com"
        newUser2.firstName = "Test2"
        newUser2.lastName = "Tester2"
        newUser2.id = 1001
        newUser2.password = "test2!"
        newUser2.phone = "867-5302"
        newUser2.username = "test2@test.com"
        newUser2.userStatus = 0
        
        UserAPI.createUsersWithArrayInput(body: [newUser, newUser2]) { (error) in
            guard error == nil else {
                XCTFail("error creating users")
                return
            }
            
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: testTimeout, handler: nil)
    }
    
    func test2GetUser() {
        let expectation = self.expectation(description: "testGetUser")
        
        UserAPI.getUserByName(username: "test@test.com") { (user, error) in
            guard error == nil else {
                XCTFail("error getting user")
                return
            }
            
            if let user = user {
                XCTAssert(user.userStatus == 0, "invalid userStatus")
                XCTAssert(user.email == "test@test.com", "invalid email")
                XCTAssert(user.firstName == "Test", "invalid firstName")
                XCTAssert(user.lastName == "Tester", "invalid lastName")
                XCTAssert(user.password == "test!", "invalid password")
                XCTAssert(user.phone == "867-5309", "invalid phone")
                
                expectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: testTimeout, handler: nil)
    }
    
    func test3DeleteUser() {
        let expectation = self.expectation(description: "testDeleteUser")
        
        UserAPI.deleteUser(username: "test@test.com") { (error) in
            guard error == nil else {
                XCTFail("error deleting user")
                return
            }

            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: testTimeout, handler: nil)
    }

    func testPathParamsAreEscaped() {
        // The path for this operation is /user/{userId}. In order to make a usable path,
        // then we must make sure that {userId} is percent-escaped when it is substituted
        // into the path. So we intentionally introduce a path with spaces.
        let userRequestBuilder = UserAPI.getUserByNameWithRequestBuilder(username: "User Name With Spaces")
        let urlContainsSpace = userRequestBuilder.URLString.contains(" ")

        XCTAssert(!urlContainsSpace, "Expected URL to be escaped, but it was not.")
    }

}

//
//  AuthenticationServiceTests.swift
//  ServiceTests
//
//  Created by Diana Ivascu on 12/26/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import XCTest
@testable import Service

class AuthenticationServiceTests: XCTestCase {
    
    private var mockNetwork: MockNetwork!
    private var authenticationService: OAuthService!
    private var credentialStore: MockCredentialStore!
    private var authenticationDelegate: MockAuthenticationDelegate!
    private let authenticationUrlBuilder = AuthenticationUrlBuilder(authKey: "authKey")
    
    override func setUp() {
        
        super.setUp()
        mockNetwork = MockNetwork()
        credentialStore = MockCredentialStore()
        authenticationDelegate = MockAuthenticationDelegate()
        authenticationService = OAuthService(network: mockNetwork,
                                                      urlBuilder: authenticationUrlBuilder,
                                                      credentialStore: credentialStore)
        authenticationService.delegate = authenticationDelegate
    }
    
    override func tearDown() {
        
        mockNetwork = nil
        credentialStore = nil
        authenticationDelegate = nil
        authenticationService = nil
        super.tearDown()
    }
    
    func testSuccessfulAuthentication() {
        
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.url(forResource: "MockValidAuthenticationResponse",
                                    withExtension: "json"),
            let jsonData = try? Data(contentsOf: path) else {
                
                XCTFail("Could not load test data from file.")
                return
        }
        
        mockNetwork.data = jsonData
        let authenticationDataExpectation = expectation(description: "\(#function)")
        
        authenticationDelegate.email = "testemail@test.com"
        authenticationDelegate.password = "testPassword"
        authenticationService.authenticate { (success) in
            
           XCTAssertEqual(success, true)
           authenticationDataExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                
                XCTFail("Expectations did timeout with error: \(error)")
            }
        }
    }
    
    func testSuccessfulRefreshAuthentication() {
        
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.url(forResource: "MockValidRefreshAuthenticationResponse",
                                    withExtension: "json"),
            let jsonData = try? Data(contentsOf: path) else {
                
                XCTFail("Could not load test data from file.")
                return
        }
        
        credentialStore.refreshToken = "refreshToken"
        mockNetwork.data = jsonData
        let authenticationDataExpectation = expectation(description: "\(#function)")
        
        authenticationService.authenticate { (success) in
            
            XCTAssertEqual(success, true)
            authenticationDataExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                
                XCTFail("Expectations did timeout with error: \(error)")
            }
        }
    }
    
    func testFailedRefreshAuthentication() {
        
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.url(forResource: "MockInvalidRefreshAuthenticationResponse",
                                    withExtension: "json"),
            let jsonData = try? Data(contentsOf: path) else {
                
                XCTFail("Could not load test data from file.")
                return
        }
        
        credentialStore.refreshToken = "refreshToken"
        mockNetwork.data = jsonData
        let authenticationDataExpectation = expectation(description: "\(#function)")
        
        authenticationService.authenticate { (success) in
            
            XCTAssertEqual(success, false)
            authenticationDataExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                
                XCTFail("Expectations did timeout with error: \(error)")
            }
        }
    }
    
    func testAuthenticationWithNoDelegate() {
        
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.url(forResource: "MockValidAuthenticationResponse",
                                    withExtension: "json"),
            let jsonData = try? Data(contentsOf: path) else {
                
                XCTFail("Could not load test data from file.")
                return
        }
        
        mockNetwork.data = jsonData
        let authenticationDataExpectation = expectation(description: "\(#function)")
        
        authenticationService.delegate = nil
        authenticationService.authenticate { (success) in
            
            XCTAssertEqual(success, false)
            authenticationDataExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                
                XCTFail("Expectations did timeout with error: \(error)")
            }
        }
    }
    
    func testAuthenticationUserCancelled() {
        
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.url(forResource: "MockValidAuthenticationResponse",
                                    withExtension: "json"),
            let jsonData = try? Data(contentsOf: path) else {
                
                XCTFail("Could not load test data from file.")
                return
        }
        
        mockNetwork.data = jsonData
        let authenticationDataExpectation = expectation(description: "\(#function)")
        
        authenticationDelegate.email = "testemail@test.com"
        authenticationDelegate.password = "testPassword"
        authenticationDelegate.isCancelled = true
        authenticationService.authenticate { (success) in
            
            XCTAssertEqual(success, false)
            authenticationDataExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                
                XCTFail("Expectations did timeout with error: \(error)")
            }
        }
    }
    
    func testRefreshAuthenticationNoData() {
        
        credentialStore.refreshToken = "refreshToken"
        mockNetwork.data = nil
        let authenticationDataExpectation = expectation(description: "\(#function)")
        
        authenticationService.authenticate { (success) in
            
            XCTAssertEqual(success, false)
            authenticationDataExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                
                XCTFail("Expectations did timeout with error: \(error)")
            }
        }
    }
    
    func testCurrentAuthenticatedUser() {
        
        let currentUser = "testCurrentUser"
        credentialStore.currentUser = currentUser
        
        XCTAssertEqual(authenticationService.currentUser, credentialStore.currentUser)
    }
}

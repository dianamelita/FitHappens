//
//  FBFitnessEventServiceTests.swift
//  ServiceTests
//
//  Created by Diana Ivascu on 11/9/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import XCTest
@testable import Service
import Networking
import Model

class FBFitnessEventServiceTests: XCTestCase {
    
    let date = Date(timeIntervalSince1970: 1563494400)
    var mockNetwork: MockNetwork!
    var fbFitnessEventService: FBFitnessEventService!
    
    override func setUp() {
        
        super.setUp()
        mockNetwork = MockNetwork()
        fbFitnessEventService  = FBFitnessEventService(urlBuilder: FitnessEventUrlBuilder(),
                                                       network: mockNetwork)
    }
    
    override func tearDown() {
        
        mockNetwork = nil
        fbFitnessEventService = nil
        super.tearDown()
    }
    
    func testRetrieveEvents() {
        
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.url(forResource: "MockValidFitnessEventsResponse",
                                    withExtension: "json"),
              let jsonData = try? Data(contentsOf: path) else {
                
                XCTFail("Could not load test data from file.")
                return
        }
        
        mockNetwork.data = jsonData
        let eventsRetrievalExpectation = expectation(description: "\(#function)")
        
        fbFitnessEventService.retrieveEvents(from: date) { (fitnessEventArray, error) in
            
            XCTAssertEqual(fitnessEventArray?.count, 4)
            XCTAssertNil(error)
            eventsRetrievalExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                
                XCTFail("Expectations did timeout with error: \(error)")
            }
        }
    }
    
    func testNoEventsRetrievedWithError() {
        
        let nilDataError = ServiceTestError.unitTestError
        mockNetwork.error = nilDataError
        let eventsRetrievalExpectation = expectation(description: "\(#function)")
        
        fbFitnessEventService.retrieveEvents(from: date) { (fitnessEventArray, error) in
            
            XCTAssertNil(fitnessEventArray)
            XCTAssertNotNil(error)
            eventsRetrievalExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                
                XCTFail("Expectations did timeout with error: \(error)")
            }
        }
    }
    
    func testNoEventsRetrievedWithNoError() {
       
        let eventsRetrievalExpectation = expectation(description: "\(#function)")
        
        fbFitnessEventService.retrieveEvents(from: date) { (fitnessEventArray, error) in
            
            XCTAssertNil(fitnessEventArray)
            XCTAssertNotNil(error)
            eventsRetrievalExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                
                XCTFail("Expectations did timeout with error: \(error)")
            }
        }
    }
    
    func testEventsRetrievalMalformedData() {
        
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.url(forResource: "MockInvalidFitnessEventsResponse",
                                    withExtension: "json"),
            let jsonData = try? Data(contentsOf: path) else {
                
                XCTFail("Could not load test data from file.")
                return
        }
        
        mockNetwork.data = jsonData
        let eventsRetrievalExpectation = expectation(description: "\(#function)")
        
        fbFitnessEventService.retrieveEvents(from: date) { (fitnessEventArray, error) in
            
            XCTAssertNil(fitnessEventArray)
            XCTAssertNotNil(error)
            eventsRetrievalExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Expectations did timeout with error:\(error)")
            }
        }
    }
}

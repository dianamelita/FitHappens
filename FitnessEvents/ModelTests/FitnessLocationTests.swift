//
//  FitnessLocationTests.swift
//  ModelTests
//
//  Created by Diana Ivascu on 11/3/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import XCTest
@testable import Model

class FitnessLocationTests: XCTestCase {
    
    func testDecodeLocationSuccess() {
        
        let correctJsonEvent = """
                                {
                                "address": "Knock Mill Lane",
                                "city": "West Kingsdown",
                                "postCode": "TN15 6AH",
                                "venueName": "Heritage Pine Forest"
                                }
                                """
        
        let eventData: Data! = correctJsonEvent.data(using: .utf8)
        
        do {
            
            let jsonDecoder = JSONDecoder()
            let location = try jsonDecoder.decode(Location.self, from: eventData)
            XCTAssertEqual(location.address, "Knock Mill Lane")
            XCTAssertEqual(location.city, "West Kingsdown")
            XCTAssertEqual(location.postalCode, "TN15 6AH")
            XCTAssertEqual(location.venue, "Heritage Pine Forest")
            
        } catch {
            
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
    }
    
    func testDecodeLocationFail() {
        
        let incorrectJsonEvent = """
                                   {
                                    "address": "Knock Mill Lane",
                                    "city": 99,
                                    "postCode": "TN15 6AH",
                                    "venueName": "Heritage Pine Forest"
                                   }
                                 """
        
        let eventData: Data! = incorrectJsonEvent.data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        XCTAssertThrowsError(try jsonDecoder.decode(Location.self, from: eventData))
    }
}

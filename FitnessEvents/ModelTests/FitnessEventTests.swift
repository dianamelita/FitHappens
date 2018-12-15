//
//  ModelTests.swift
//  ModelTests
//
//  Created by Diana Ivascu on 11/1/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import XCTest
@testable import Model

class FitnessEventTests: XCTestCase {
    
    func testDecodeFitnessEventSuccess() {
        
        let correctJsonEvent = """
                                {
                                "endDate": "2019-07-21T23:00:00Z",
                                "iconLink": "https://www.unittest.com",
                                "id": "1000",
                                "location": {
                                    "address": "Knock Mill Lane",
                                    "city": "West Kingsdown",
                                    "postCode": "TN15 6AH",
                                    "venueName": "Heritage Pine Forest"
                                },
                                "name": "LoveFit",
                                "price": 99,
                                "startDate": "2019-07-19T08:00:00Z",
                                "websiteLink": "https://www.lovefitfestival.com"
                                }
                                """
        
        let eventData: Data! = correctJsonEvent.data(using: .utf8)
        
        do {
            
            let jsonDecoder = JSONDecoder()
            let event = try jsonDecoder.decode(FitnessEvent.self, from: eventData)
            
            XCTAssertEqual(event.id, "1000")
            XCTAssertEqual(event.icon, URL(string: "https://www.unittest.com"))
            XCTAssertEqual(event.end, Date(timeIntervalSince1970: 1563750000))
            XCTAssertEqual(event.name, "LoveFit")
            XCTAssertEqual(event.price, 99)
            XCTAssertEqual(event.start, Date(timeIntervalSince1970: 1563523200))
            XCTAssertEqual(event.website, URL(string: "https://www.lovefitfestival.com"))
            XCTAssertNotNil(event.location)
            
        } catch {
            
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
    }
    
    func testDecodeFitnessEventFail() {
        
        let correctJsonEvent = """
                                {
                                "endDate": "2019-07-21T23:00:00Z",
                                "iconLink": "https://www.unittest.com",
                                "location": {
                                    "address": "Knock Mill Lane",
                                    "city": "West Kingsdown",
                                    "postCode": "TN15 6AH",
                                    "venueName": "Heritage Pine Forest"
                                },
                                "name": "LoveFit",
                                "price": 99,
                                "startDate": "2019-07-19T08:00:00Z",
                                "websiteLink": "https://www.lovefitfestival.com"
                                }
                                """
        
        let eventData: Data! = correctJsonEvent.data(using: .utf8)
        
        let jsonDecoder = JSONDecoder()
        XCTAssertThrowsError(try jsonDecoder.decode(FitnessEvent.self, from: eventData))
    }
}

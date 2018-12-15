//
//  FitnessEventUrlBuilderTests.swift
//  ServiceTests
//
//  Created by Diana Ivascu on 11/1/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import XCTest
@testable import Service

class FitnessEventUrlBuilderTests: XCTestCase {

   let urlBuilder = FitnessEventUrlBuilder()
    
    func testSuccessUrlBuilderWithDate() {
        
        let date = Date(timeIntervalSince1970: 1563494400)
        let fitnessEventsUrl = urlBuilder.fitnessEventsUrl(withStartDate: date)
        
        let expectedUrl = URL(string: "https://fitnessevents-163d1.firebaseio.com/events.json?orderBy=%22startDate%22&startAt=%222019-07-19%22")
        
        XCTAssertEqual(fitnessEventsUrl, expectedUrl)
    }
}

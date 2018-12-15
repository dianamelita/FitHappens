//
//  FitnessEventUrlBuilder.swift
//  Service
//
//  Created by Diana Ivascu on 11/5/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public class FitnessEventUrlBuilder {
    
    private let baseUrl: URL! = URL(string: "https://fitnessevents-163d1.firebaseio.com/events.json")
    
    func fitnessEventsUrl(withStartDate date: Date) -> URL? {
        
        let orderByElement = URLQueryItem(name: "orderBy", value: "\"startDate\"")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = formatter.string(from: date)
        let dateElement = URLQueryItem(name: "startAt", value: "\"\(dateString)\"")        
        var urlComponents = URLComponents(url: self.baseUrl,
                                          resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [orderByElement, dateElement]
        
        return urlComponents?.url
    }
}

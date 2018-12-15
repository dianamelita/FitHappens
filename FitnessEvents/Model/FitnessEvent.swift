//
//  FitnessEvent.swift
//  Model
//
//  Created by Diana Ivascu on 11/3/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public struct FitnessEvent {
    
    public let id: String
    public let name: String
    public let start: Date
    public let end: Date
    public let location: Location
    public let price: Double
    public let website: URL
    public let icon: URL?
    
    private static var dateFormatter: DateFormatter {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        return dateFormatter
    }
}

extension FitnessEvent: Decodable {
    
   private enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case startDate
        case endDate
        case location
        case price
        case websiteLink
        case iconLink
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        let startDateString = try container.decode(String.self, forKey: .startDate)
        guard let startDateFormatted = FitnessEvent.dateFormatter.date(from: startDateString) else {
            throw ParsingError.dateConversionFailure(details: "Failed to create date from string \(startDateString) using format \(FitnessEvent.dateFormatter.dateFormat ?? "none")") }
        start = startDateFormatted
        
        let endDateString = try container.decode(String.self, forKey: .endDate)
        guard let endDateFormatted = FitnessEvent.dateFormatter.date(from: endDateString) else {
            throw ParsingError.dateConversionFailure(details: "Failed to create date from string \(endDateString) using format \(FitnessEvent.dateFormatter.dateFormat ?? "none")") }
        end = endDateFormatted

        price = try container.decode(Double.self, forKey: .price)
        website = try container.decode(URL.self, forKey: .websiteLink)
        icon = try container.decodeIfPresent(URL.self, forKey: .iconLink)
        location = try container.decode(Location.self, forKey: .location)
    }
}

//
//  Location.swift
//  Model
//
//  Created by Diana Ivascu on 11/3/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public struct Location: CustomStringConvertible {
    
   public let address: String?
   public let city: String
   public let venue: String?
   public let postalCode: String
   public var description: String {
        
        let locationArray = [venue, address, city, postalCode].compactMap { $0 }
        return locationArray.joined(separator: ", ")
    }
}

extension Location: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        
        case address
        case city
        case postalCode = "postCode"
        case venue = "venueName"
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        address = try container.decodeIfPresent(String.self, forKey: .address)
        city = try container.decode(String.self, forKey: .city)
        venue = try container.decodeIfPresent(String.self, forKey: .venue)
        postalCode = try container.decode(String.self, forKey: .postalCode)
    }
}

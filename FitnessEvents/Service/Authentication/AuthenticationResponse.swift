//
//  AuthenticationResponse.swift
//  Service
//
//  Created by Diana Ivascu on 12/22/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

struct AuthenticationResponse {
    
    let id: String
    let email: String
    let token: String
    let refreshToken: String
    let expiresIn: String
}

extension AuthenticationResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        
        case id = "localId"
        case email
        case token = "idToken"
        case refreshToken
        case expiresIn
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        token = try container.decode(String.self, forKey: .token)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        expiresIn = try container.decode(String.self, forKey: .expiresIn)
    }
}

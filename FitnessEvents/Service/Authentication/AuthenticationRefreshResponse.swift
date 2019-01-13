//
//  AuthenticationRefreshResponse.swift
//  Service
//
//  Created by Diana Ivascu on 12/22/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

struct AuthenticationRefreshResponse {
    
    let token: String
    let refreshToken: String
    let expiresIn: String
}

extension AuthenticationRefreshResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        
        case token = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        expiresIn = try container.decode(String.self, forKey: .expiresIn)        
    }
}

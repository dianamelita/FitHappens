//
//  AuthenticationError.swift
//  Service
//
//  Created by Diana Ivascu on 12/23/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public enum AuthenticationError {
    
    case noDelegate(details: String)
    case noCredentials(details: String)
    case userCancelled(details: String)
}

extension AuthenticationError: LocalizedError {
    
    public var errorDescription: String? {
        
        switch self {
            
        case .noDelegate(let details),
             .noCredentials(let details),
             .userCancelled(let details):
            return "Details: \(details)"
        }
    }
}

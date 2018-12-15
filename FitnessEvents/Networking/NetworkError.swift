//
//  NetworkError.swift
//  Networking
//
//  Created by Diana Ivascu on 11/4/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    
    case httpResponseFail(details: String)
}

extension NetworkError: LocalizedError {
    
    public var errorDescription: String? {
        
        switch self {
            
        case .httpResponseFail(let details):
            
            return "Details: \(details)"
        }
    }
}

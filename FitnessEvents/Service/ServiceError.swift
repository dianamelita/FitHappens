//
//  ServiceError.swift
//  Service
//
//  Created by Diana Ivascu on 11/7/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public enum ServiceError: Error {
    
    case urlBuilderFail(details: String)
    case noDataRetrieved(details: String)
    case malformedData(details: String)
}

extension ServiceError: LocalizedError {
    
    public var errorDescription: String? {
        
        switch self {
            
        case .urlBuilderFail(let details),
             .noDataRetrieved(let details),
             .malformedData(let details):
            
            return "Details: \(details)"
        }
    }
}

//
//  MockCredentialStore.swift
//  ServiceTests
//
//  Created by Diana Ivascu on 12/28/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import Service
import Logging

class MockCredentialStore: CredentialStore {
    
    var token: String? = nil
    var refreshToken: String? = nil
    var currentUser: String? = nil
    
    func store(value: String, at key: String) { }
    
    func retrieve(key: String) -> String? {
        
        switch(key) {
            
        case "token":
            return token
        case "refreshToken":
            return refreshToken
        case "currentUser":
            return currentUser
        default:
            return nil
        }
    }
    
    func clear() { }
}

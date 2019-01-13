//
//  SecureCredentialStore.swift
//  Service
//
//  Created by Diana Ivascu on 12/27/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import KeychainAccess
import Logging

class SecureCredentialStore: CredentialStore {
    
    private let keychain = Keychain(service: "com.diana.fithappens.authenticationSerivce")

    func store(value: String, at key: String) {
        
        do {
            
            try keychain.set(value, key: key)
        }
        catch let error {
            
            log.debugMessage("Could not save key \(key) with value \(value) in keychain. Returned with error: \(error)")
        }
    }
    
    func retrieve(key: String) -> String? {
        
        guard let value = keychain[key] else {
            
            return nil
        }
        return value
    }
    
    func clear() {
        
        do {
            
            try keychain.removeAll()
        } catch {
            
            log.debugMessage("Error: \(error) received when trying to clear the keychain.")
        }
    }
}

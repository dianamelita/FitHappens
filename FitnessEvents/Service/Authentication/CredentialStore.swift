//
//  CredentialStore.swift
//  Service
//
//  Created by Diana Ivascu on 12/27/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public protocol CredentialStore {
    
    func store(value: String, at key: String)
    func retrieve(key: String) -> String?
    func clear() -> Void
}

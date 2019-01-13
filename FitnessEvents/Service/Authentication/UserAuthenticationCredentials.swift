//
//  UserAuthenticationCredentials.swift
//  Service
//
//  Created by Diana Ivascu on 12/22/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public struct UserAuthenticationCredentials {
    
    let email: String
    let password: String
    
    public init(email: String,
                password: String) {
        
        self.email = email
        self.password = password
    }
}

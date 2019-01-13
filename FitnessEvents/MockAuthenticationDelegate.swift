//
//  MockAuthenticationDelegate.swift
//  ServiceTests
//
//  Created by Diana Ivascu on 12/26/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import Service

class MockAuthenticationDelegate: AuthenticationServiceDelegate {
    
    var email: String? = nil
    var password: String? = nil
    var isCancelled: Bool = false
    
    func retrieveCredentials(completion: (UserAuthenticationCredentials?, Bool, ((Error?) -> Void)?) -> Void) {
        
        if let email = email,
           let password = password {
            
            let userCredentials = UserAuthenticationCredentials(email: email,
                                                                password: password)
            completion(userCredentials, isCancelled) { _ in }
        } else {
            
            completion(nil, isCancelled) { _ in }
        }        
    }
}
